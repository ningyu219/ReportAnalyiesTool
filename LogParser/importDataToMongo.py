import pymongo
import logging
import xlrd
from optparse import OptionParser

DB_URL = "127.0.0.1"
DB_PORT = 27017

log = logging.getLogger('importDataToMongo')
log.setLevel(logging.DEBUG)

Case_Mapping_Sheet_Name = "all_cases"

def get_post_data(path, sheetname):
    data = xlrd.open_workbook(path)
    table = data.sheet_by_name(sheetname)

    nrows = table.nrows
    ncols = table.ncols

    total_mapper = []
    row_mapper = []

    CYCLEID_IDX = 0
    TESTCYCLEID_IDX=1
    TESTID_IDX = 2
    USER27_IDX = 3
    CASENAME_IDX = 4 #Testcase name,TS_USER_37
    TESTSET_IDX = 5#TS_USER_24
    PRODUCT_IDX = 6#TS_USER_03
    TESTNAMEALM_IDX = 7#TS_NAME
    TESTCYCLE_IDX = 8

    case_mapper = {}

    for i in range(1, nrows):
        row_mapper = {
            "testName":table.row_values(i)[CASENAME_IDX],
            "testSet": table.row_values(i)[TESTSET_IDX],
            "testCycle": table.row_values(i)[TESTCYCLE_IDX],
            "product": table.row_values(i)[PRODUCT_IDX],
            "testID": table.row_values(i)[TESTID_IDX],
            "cycleID":table.row_values(i)[CYCLEID_IDX],
            "testcycleID": table.row_values(i)[TESTCYCLEID_IDX],
            "user27": table.row_values(i)[USER27_IDX],
            "testNameALM": table.row_values(i)[TESTNAMEALM_IDX]
        }
        total_mapper.append(row_mapper)

    return total_mapper

def insert_to_db(post_data):
    client = pymongo.MongoClient(DB_URL,DB_PORT)
    db = client.alm_database
    collection = db.case_mapping
    #post_data_id = collection.insert(post_data).inserted_id
    collection.insert(post_data)
    log.info("")

def main():
    usage = "usage: python -T <tag> -M <file path> "
    parser = OptionParser(usage=usage, epilog="")
    parser.add_option("-M", "--mapping", type="string", help="indicate the mapping file path")
    (options, args) = parser.parse_args()

    log.info("Start to parse post data")
    print options.mapping
    post_data = get_post_data(options.mapping, Case_Mapping_Sheet_Name)
    insert_to_db(post_data)

if __name__ == "__main__":
    main()