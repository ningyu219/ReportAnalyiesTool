import pymongo

class myMongo(object):
    def __init__(self, host, port):
        try:
            self.conn = pymongo.MongoClient(host=host, port=port)
        except Exception as e:
            print("Fail to connect..", e)
        else:
            print("Success to connect..")

    def get_detail_by_testname(self,testName):
        case_detail = self.conn.alm_database.case_mapping.find_one({"testName": testName});
        return case_detail

'''
    def add(self, p_dict):
        res = self.conn.alm_database.case_mapping.insert(p_dict)
        if res:
            print("Success to insert")

    def show(self):
        res = self.conn.alm_database.case_mapping.find()
        for i in res:
            print(i)

    def mod(self, before, after):
        res = self.conn.alm_database.case_mapping.update(before, after)
        if res:
            print("Modify success", res)

    def rem(self, p_dict):
        res = self.conn.alm_database.case_mapping.delete_one(p_dict)
        if res:
            print("")
'''