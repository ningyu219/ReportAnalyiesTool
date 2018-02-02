import json
import time,base64,shutil
TIMEZOOM="+0800"
ISOTIMEFORMAT="%Y-%m-%dT%H:%M:%S"


class testCaseChunk:

    RESULTCODE2STRING = {"LogFatalError":"Fatal_Error","121":"Fail","LogFail":"Fail","120":"Fail","LogInfo":"Info","102":"Info","LogPass":"Pass","110":"Pass","LogNone":"None","100":"None","LogWarning":"Pass","115":"Pass","LogScreenShot":"ScreenShot","220":"Screenshot"}

    def __init__(self,content):
        self.logID = None
        self.logCaption = None
        self.caseName = None
        self.logFolder = None
        self.logLineCount = None
        self.machineName = None
        self.scriptFinalResult = None
        self.testName = None
        self.userID = None
        self.execute_time = None
        self.product = None

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
        self.eventID = None
        self.pumID = None
        self.buildID = None
        self.platform = None
        self.eventName = None

        self.testset = None
        self.type = None

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
        #self.product = content.get("Log").get("testName").split("_")[0]
        #self.testSuite = content.get("Log").get("testName").split("_")[2]
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

    def set_psto_info(self,eventID=None,pumID=None,buildID=None,platform=None,eventName=""):
        self.is_psto = True
        self.eventID = eventID
        self.pumID = pumID
        self.buildID = buildID
        self.platform = platform
        self.eventName = eventName

    def toDict(self):
        res = {}

        res["logID"] = self.logID
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
        res["testSuite"] = self.testSuite

        res["executionOptionName"] = self.executionOptionName

        res["reportUrl"] = self.reportLink

        res["testSet"] = self.testset

        if self.is_psto == True:
            res["eventID"] = int(self.eventID)
            res["pumID"] = self.pumID
            res["buildID"] = self.buildID
            res["platform"] = self.platform
            res["eventName"] = self.eventName

        return res
