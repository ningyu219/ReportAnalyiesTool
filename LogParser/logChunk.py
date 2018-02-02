

class logChunk:

    PSTO = "psto"

    def __init__(self,root_dir=None,type=None):
        self.root_dir = root_dir
        self.type = type




class PSTOLogChunk(logChunk):

    def __init__(self,root_dir=None,case_name=None,target_xml_path=None):
        logChunk.__init__(self,root_dir,logChunk.PSTO)
        self.case_name = case_name
        self.target_xml_path = target_xml_path
        self.test_set = None
        self.case_type = None
        self.prod = None
        self.report_obj=None
        self.__format__()

    def __format__(self):
        assert (len(self.root_dir.split("_")) == 6)
        self.src, self.platform, self.pum, self.build, self.date, self.runID = self.root_dir.split("_")