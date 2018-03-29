

class logChunk:

    PSTO = "psto"
    UOW = "uow"

    def __init__(self,root_dir=None,type=None,case_name=None,target_xml_path=None):
        self.root_dir = root_dir
        self.type = type
        self.test_set = None
        self.case_type = None
        self.product = None
        self.domain = None
        self.report_obj = None
        self.case_name = case_name
        self.target_xml_path = target_xml_path

class PSTOLogChunk(logChunk):

    def __init__(self,root_dir=None,case_name=None,target_xml_path=None):
        logChunk.__init__(self,root_dir,logChunk.PSTO,case_name,target_xml_path)
        self.src1 = None
        self.src2 = None
        self.platform = None
        self.pum = None
        # self.build is split to No and Type (C556-R1/C570-GLD)
        self.build = None
        self.buildNo = None
        self.buildType = None
        self.dateStamp = None
        self.runID = None
        self.__format__()

    def __format__(self):
        # PRODUCTION RUN NAME: PSTO_ONFS_PI26_C556-R1_171122_490
        if len(self.root_dir.split("_")) == 6:
            self.src1, self.platform, self.pum, self.build, self.dateStamp, self.runID = self.root_dir.split("_")
            self.buildNo, self.buildType = self.build.split("-")
        # STAGE RUN NAME: PSTO_STG_ONCS_PI28_C570-GLD_180307_866
        if len(self.root_dir.split("_")) == 7:
            self.src1, self.src2, self.platform, self.pum, self.build, self.dateStamp, self.runID = self.root_dir.split("_")
            self.buildNo, self.buildType = self.build.split("-")


class UOWLogChunk(logChunk):
    def __init__(self, root_dir=None, case_name=None, target_xml_path=None):
        logChunk.__init__(self, root_dir, logChunk.UOW,case_name,target_xml_path)
        self.uowID = None
        self.excuteDB = None
        self.executorEmail = None
        self.dateStamp = None
        self.__format__()

    def __format__(self):
        assert (len(self.root_dir.split("_")) == 5)
        _,self.uowID, self.excuteDB, self.executorEmail, self.dateStamp = self.root_dir.split("_")