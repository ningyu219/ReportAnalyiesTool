import logging
from optparse import OptionParser
import os,traceback
from elasticsearch import helpers
from elasticsearch import Elasticsearch
import json
from utils.xmltodict import xmltodict
from utils.xmltohtml.xmlToHTML import convertXML2HTML
import time,base64,shutil
from testCaseChunk import testCaseChunk
from logChunk import PSTOLogChunk,logChunk,UOWLogChunk
from utils.helper import get_case_mapping

logging.basicConfig(format='%(asctime)s-%(process)d-%(levelname)s: %(message)s')
log = logging.getLogger('result_analysis')
log.setLevel(logging.DEBUG)


ES_URL = "http://localhost"
ES_PORT = "9200"
ES_INDEX = "ptf_report" # include PSTO and UOW
ES_SUMMARY_INDEX = "psto_summary"
ES_COMMIT_QUEUE = []
ES_COMMIT_QUEUE_MAX = 200
Case_Mapping_Sheet_Name = "Staging_Cases"
es_instance = Elasticsearch(ES_URL + ":" + ES_PORT, timeout=30)

prodFMSList = ['Asset Management','Accounts Payable','Accounts Receivable','Contracts','Cash Management','Deal Management','Expenses','General Ledger','Grants','Lease Administration','Maintenance Management','Project Costing','Program Management','Resource Management'];
prodSCMList = [];


WEBSERVICE_URL="http://127.0.0.1"
WEBSERVICE_PORT="5000"

LOGDIR = None


def log_parser(task,result_summary):

    #convert xml to html
    current_dir = os.path.dirname(os.path.realpath(__file__))
    xsl_path = current_dir+"\\style\\ToolsAutoStyle.xsl"

    target_html_dir = os.path.dirname(os.path.realpath(task.target_xml_path))
    target_html_name = task.target_xml_path.split("\\")[-1].split(".")[0] + ".html"
    target_html = target_html_dir +"\\"+target_html_name
    target_html_relative_path = target_html.replace(LOGDIR,"")

    #parser xml

    try:

        convertXML2HTML(xml_path=task.target_xml_path, xsl_path=xsl_path,html_path=target_html_dir + "\\" + target_html_name)

        result_chunk_obj = task.report_obj
        result_chunk_obj.reportLink = WEBSERVICE_URL + ":"+WEBSERVICE_PORT+"/logpath"+target_html_relative_path.replace("\\","/")
        result_chunk_obj.logType = task.type
        result_chunk_obj.domain = task.domain
        result_chunk_obj.product = task.product
        # get log root dir to extract psto info
        #log_root_dir = task.target_xml_path.replace(LOGDIR, "").split("\\")[1]
        #src = log_root_dir.split("_")[0]
        if task.type == logChunk.PSTO:
            result_chunk_obj.set_psto_info(eventID=task.runID, pumID=task.pum, buildNo=task.buildNo, buildType=task.buildType, platform=task.platform, src2=task.src2, dateStamp=task.dateStamp)
        elif task.type == logChunk.UOW:
            result_chunk_obj.set_uow_info(uowID=task.uowID,excuteDB=task.excuteDB,executorEmail=task.executorEmail,dateStamp=task.dateStamp)
        else:
            assert 0, "unsupport task type"

        result_chunk_obj.testSet = task.test_set
        result_chunk_obj.caseType = task.case_type
        if task.product != "unknown":
            result_chunk_obj.product = task.product


        if result_summary.get(result_chunk_obj.eventID) == None:
            result_summary[result_chunk_obj.eventID] = {}
        if result_summary.get(result_chunk_obj.eventID).get(result_chunk_obj.product) == None:
            result_summary[result_chunk_obj.eventID][result_chunk_obj.product] = {}
        if result_summary.get(result_chunk_obj.eventID).get(result_chunk_obj.product).get(result_chunk_obj.testSet) == None:
            result_summary[result_chunk_obj.eventID][result_chunk_obj.product][result_chunk_obj.testSet] = {"pass":0,"failed":0}

        if result_chunk_obj.scriptFinalResult == "Pass":
            result_summary[result_chunk_obj.eventID][result_chunk_obj.product][result_chunk_obj.testSet]["pass"] +=1
        else:
            result_summary[result_chunk_obj.eventID][result_chunk_obj.product][result_chunk_obj.testSet][
                "failed"] += 1

        return result_chunk_obj.toDict(),result_summary

    except Exception as e:
        formatted_lines = traceback.format_exc()
        log.error("reading %s exception"%task.target_xml_path)
        log.error("traceback:  %s",formatted_lines)


    return None


def result_chunk_handler(res,commit):

    if commit == True:

        commit2ES(res)

    else:

        log.info(res)


def commit2ES(res):

    _head =  {"_index":ES_INDEX,"_type":"result"}

    res.update(_head)

    ES_COMMIT_QUEUE.append(res)

    if len(ES_COMMIT_QUEUE) >= ES_COMMIT_QUEUE_MAX:

        committer(es_instance,ES_COMMIT_QUEUE)



def committer(es_instance,msgs):

        retry_counter = 0

        while(1):
            try:
                result = helpers.bulk(es_instance,msgs)
                log.info("ES Commit: " + str(result[0]))
                del msgs[0:result[0]]
                break
            except Exception as e:
                if retry_counter < 5:
                    retry_counter +=1
                    log.info("Commit To ES Exception, Retry")
                    continue
                else:
                    log.error("Commit To ES Exception 5 times")
                    break

'''
def get_task_list(path):
    files = os.listdir(path)
    for fi in files:
        fi_d = os.path.join(path,fi)
        if os.path.isdir(fi_d):
            get_task_list(fi_d)
        else:
            if fi_d.split(".")[1] != "xml":
                continue
            taskList.append(os.path.join(path,fi_d))
'''

def get_task_list(path, case_mapper,targetType):
    taskList=[]
    for root,dirs,files in os.walk(path):
        root_dir = root.split("\\")[-1]
        for dir in dirs:
            log.info("start analysis report in:%s"%(dir))
            tempList = []
            flag = 0
            for root2, dirs2, files2 in os.walk(os.path.join(root,dir)):
                for fi in files2:
                    fi_d = os.path.join(root2, fi)
                    if fi_d.find(".xml") >= 0:
                        if targetType == "PSTO":
                            task = PSTOLogChunk(root_dir, dir, fi_d)
                        elif targetType == "UOW":
                            task = UOWLogChunk(root_dir,dir,fi_d)
                        else:
                            log.error("unsupport log type%s"%(targetType))
                        tempList.append(task)
                for task in tempList:
                    task.report_obj = get_report_obj(task.target_xml_path)
                    if case_mapper.get(task.case_name) == None:
                        log.error(task.case_name + " not in mapper")
                        task.test_set = "unknown"
                        task.product = "unknown"
                        task.case_type = "unknown"
                        task.domain = "unknown"
                    else:
                        task.test_set = case_mapper.get(task.case_name).get("testSet")
                        task.case_type = case_mapper.get(task.case_name).get("testCycle")
                        task.product = case_mapper.get(task.case_name).get("product")
                        if task.product in prodFMSList:
                            task.domain = "FMS"
                        else:
                            task.domain = "SCM"

                    if task.report_obj.scriptFinalResult == "Pass":
                        taskList.append(task)
                        break
                    else:
                        flag = flag+1
                if flag == len(tempList):
                    taskList.append(tempList[-1])
                    flag = 0

    return taskList


def get_report_obj(log_path):
    file_object = open(log_path)
    content = file_object.read()
    result_chunk_obj = testCaseChunk(json.dumps(xmltodict.parse(content)))
    return result_chunk_obj


def test_summary_handle(test_summary):
    test_set_summary_list = []
    product_summary_list=[]
    eventID_summary_list=[]
    for run_id in test_summary.keys(): #loop each event id
        event_pass_counter = 0
        event_fail_counter = 0
        event_summary = {"eventID": run_id, "passRate": "","subType":"eventPR"}
        for product in test_summary[run_id].keys(): #loop each product
            product_pass_counter = 0
            product_failed_counter = 0
            product_summary = {"eventID":int(run_id),"product":product,"passRate":0.0,"subType":"productPR"}
            for test_set in test_summary[run_id][product]:  #loop each test_set
                test_set_summary = {"eventID":"","product":"","testSet":"","passRate":0.0,"subType":"testSetPR"}
                test_set_summary["eventID"] = int(run_id)
                test_set_summary["product"] = product
                test_set_summary["testSet"] = test_set
                test_set_pass_counter = test_summary.get(run_id).get(product).get(test_set).get("pass")
                test_set_fail_counter = test_summary.get(run_id).get(product).get(test_set).get("failed")
                product_pass_counter += test_set_pass_counter
                product_failed_counter += test_set_fail_counter

                test_set_summary["passRate"] = round((float(test_set_pass_counter)/float(test_set_pass_counter+test_set_fail_counter)),4)*100
                test_set_summary_list.append(test_set_summary)

            product_summary["passRate"] = round((float(product_pass_counter)/float(product_pass_counter+product_failed_counter)),4)*100
            product_summary_list.append(product_summary)

            event_pass_counter += product_pass_counter
            event_fail_counter += product_failed_counter
        event_summary["passRate"] = round((float(event_pass_counter)/float(event_pass_counter+event_fail_counter)),4)*100
        eventID_summary_list.append(event_summary)

    summary_list = []
    summary_list.extend(eventID_summary_list)
    summary_list.extend(product_summary_list)
    summary_list.extend(test_set_summary_list)
    return summary_list


def commit_summary(summary_list):

    _head = {"_index": ES_SUMMARY_INDEX, "_type": "result"}
    ES_COMMIT_QUEUE = []
    for summary in summary_list:
        summary.update(_head)

        ES_COMMIT_QUEUE.append(summary)

        if len(ES_COMMIT_QUEUE) >= ES_COMMIT_QUEUE_MAX:
            committer(es_instance, ES_COMMIT_QUEUE)

    if len(ES_COMMIT_QUEUE) > 0:
        committer(es_instance, ES_COMMIT_QUEUE)

def get_task_source_type(path):
    logFolderName = path.split('\\')[-1]
    sourceType = logFolderName.split('_')[0]
    return sourceType

def main():
    usage = "usage: python -T <tag> -P <log path> "
    parser = OptionParser(usage=usage, epilog="")
    parser.add_option("-T", "--tag",type="string",help="tags",default="staging")
    parser.add_option("-P", "--path", type="string", help="indicate log path")
    parser.add_option("-M","--mapping",type="string",help="indicate the mapping file path")
    parser.add_option("-c", action="store_true", dest="commit")

    (options,args) = parser.parse_args()

    log.info("---------------------------Parameters-------------------------------------")
    log.info("tag:     " + options.tag)
    log.info("log path:" + options.path)
    log.info("mapping file path:%s"%options.mapping)
    log.info("commit_result:      " + str(options.commit))
    log.info("--------------------------------------------------------------------------")


    #get the case category from excel
    log.debug("get the case mapping file")
    case_mapper = get_case_mapping(options.mapping, Case_Mapping_Sheet_Name)
    log.debug("mapper:"+str(case_mapper))

    global LOGDIR
    LOGDIR = options.path

    #targetType = get_task_source_type(LOGDIR)
    logFolderName = LOGDIR.split('\\')[-1]
    targetType = logFolderName.split('_')[0]
    targetTypeSource = logFolderName.split('_')[1]

    log.info("The logs comes from "+targetType)

    #if targetType == "PSTO":
    log.debug("get task list and parse the log")
    taskList = get_task_list(LOGDIR, case_mapper, targetType)

    total_task = len(taskList)

    complete_counter = 0
    error_counter = 0

    result_chunk_list = []
    #test_summary = {"prod1":{"testSet1":{"success":number,"failed":number},"testSet2":{"success":number,"failed":number}}}
    test_summary = {}
    log.debug("start calculate the pass rate.")
    for task in taskList:
        res, test_summary = log_parser(task, test_summary)

        if res != None:
            result_chunk_list.append(res)
            complete_counter += 1
        else:
            error_counter += 1

        if complete_counter % 100 == 0:
            log.info("parser log complete: %d/%d", complete_counter, total_task)

#    log.debug(str(test_summary))

    # move the log and report from <project/logs> to <project/web/templates>
    # web_templates = os.path.dirname(os.path.realpath(__file__)) + "\\web\\templates"
    # shutil.copy(LOGDIR,web_templates)

    for res in result_chunk_list:
        result_chunk_handler(res, options.commit)

    if len(ES_COMMIT_QUEUE) > 0 and options.commit == True:
        committer(es_instance, ES_COMMIT_QUEUE)

    # handle test_summary:eg{dict}{u'Customer Bug':{'failed':1,'pass':0}}, calculate the pass rate for each product by test_set
    if targetType == "PSTO":
        summary_list = test_summary_handle(test_summary)

        if options.commit == True:
            commit_summary(summary_list)
        else:
            for summary in summary_list:
                log.info(summary)

if __name__ == "__main__":
    main()