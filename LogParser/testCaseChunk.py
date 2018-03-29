import json
import time,base64,shutil
TIMEZOOM="+0800"
ISOTIMEFORMAT="%Y-%m-%dT%H:%M:%S"


class testCaseChunk:

    RESULTCODE2STRING = {"LogFatalError":"Fatal_Error","121":"Fail","LogFail":"Fail","120":"Fail","LogInfo":"Info","102":"Info","LogPass":"Pass","110":"Pass","LogNone":"None","100":"None","LogWarning":"Pass","115":"Pass","LogScreenShot":"ScreenShot","220":"Screenshot"}

    def __init__(self,content):
        self.logID = None
        self.logType=None
        self.logCaption = None
        self.caseName = None
        self.logFolder = None
        self.logLineCount = None
        self.machineName = None
        self.scriptFinalResult = None
        self.testName = None
        self.userID = None
        self.execute_time = None


        #extra info
        self.browserVersion = None
        self.envUrl = None
        self.portal = None
        self.PTFVersion = None
        self.logPath = None

        #executionOptions
        self.executionOptionName = None

        #PSTO_ONFS_PI26_C556-R1_171112_465 info
        self.is_psto = False
        #self.src2 = None
        #self.eventID = None
        #self.pumID = None
        #self.buildNo = None
        #self.buildType = None
        #self.platform = None

        #UOW_84078_E92BISD2_nina@oracle.com_20180120213205 info
        self.is_uow = False
        # self.uowID = None
        # self.excuteDB = None
        # self.executorEmail = None
        # self.dateStamp = None

        #report link
        self.reportLink = None

        self.__parser_basic_info(json.loads(content))
        self.__parser_extra_info(json.loads(content))
        self.__parser_execution_info(json.loads(content))

    def __parser_basic_info(self,content):

        #basic info
        self.logID = content.get("Log").get("logID")
        self.logCaption = content.get("Log").get("logCaption")
        self.caseName = content.get("Log").get("caseName")
        self.logFolder = content.get("Log").get("logFolder")
        self.logLineCount = content.get("Log").get("logLineCount")
        self.machineName = content.get("Log").get("machineName")
        self.scriptFinalResult = testCaseChunk.RESULTCODE2STRING.get(content.get("Log").get("scriptFinalResult"))
        self.testName = content.get("Log").get("testName")
        self.userID = content.get("Log").get("userID")
        self.execute_time = self.__extract_execute_time(self.logCaption)


    def __parser_extra_info(self,content):
        extra_info_list = content.get("Log").get("extras").get("extra")

        for extra_info in extra_info_list:

            label = extra_info.get("logLabel")

            if label == "Browser :":
                self.browserVersion = extra_info.get("logValue")

            if label == "Env. URL :":
                self.envUrl = extra_info.get("logValue")

            if label == "PORTAL":
                self.portal = extra_info.get("logValue")

            if label == "PsTestFramework Version :":
                self.PTFVersion = extra_info.get("logValue")

            if label == "Path :":
                self.logPath = extra_info.get("logValue")



    def __parser_execution_info(self,content):

        self.executionOptionName = content.get("Log").get("executionOptions").get("executionOptionName")



    def __extract_execute_time(self,logCaption):
        y_m_d = logCaption.split(" ")[2]
        hh_mm = logCaption.split(" ")[3]

        time_str = y_m_d + "T" + hh_mm

        timestamp = time.strftime(ISOTIMEFORMAT,time.strptime(time_str, "%Y-%m-%dT%H:%M"))+TIMEZOOM

        return timestamp

    def set_psto_info(self,eventID=None,pumID=None,buildNo=None,buildType=None,platform=None, src2=None,dateStamp=""):
        self.is_psto = True
        # eg: platform: ONFS/ONCS, pumID:PI27, buildNo-buildType:C556-R1, dateStamp:180129, eventID:525,
        self.src2 = src2
        self.platform = platform
        self.pumID = pumID
        self.buildNo = buildNo
        self.buildType = buildType
        self.dateStamp = dateStamp
        self.eventID = eventID

    def set_uow_info(self,uowID = None,excuteDB=None,executorEmail=None,dateStamp=None):
        self.is_uow = True
        self.uowID = uowID
        self.excuteDB = excuteDB
        self.executorEmail = executorEmail
        self.dateStamp = dateStamp


    def toDict(self):
        res = {}

        res["logID"] = self.logID
        res["logType"] = self.logType
        res["logCaption"] = self.logCaption
        res["caseName"] = self.caseName
        res["logFolder"] = self.logFolder
        res["logLineCount"] = self.logLineCount
        res["machineName"] = self.machineName
        res["scriptFinalResult"] = self.scriptFinalResult
        res["testName"] = self.testName
        res["userID"] = self.userID
        res["executeTime"] = self.execute_time
        res["browserVersion"] = self.browserVersion
        res["envUrl"] = self.envUrl
        res["portal"] = self.portal
        res["PTFVersion"] = self.PTFVersion
        res["logPath"] = self.logPath
        res["product"] = self.product
        res["domain"] = self.domain
        res["testSet"] = self.testSet

        res["executionOptionName"] = self.executionOptionName

        res["reportUrl"] = self.reportLink

        if self.is_psto == True:
            res["eventID"] = int(self.eventID)
            res["platform"] = self.platform
            res["src2"] = self.src2
            res["pumID"] = self.pumID
            res["buildNo"] = self.buildNo
            res["buildType"] = self.buildType
            res["dateStamp"]=self.dateStamp

        if self.is_uow == True:
            res["uowID"] = self.uowID
            res["excuteDB"] = self.excuteDB
            res["executorEmail"] = self.executorEmail
            res["dateStamp"] = self.dateStamp


        return res
