import xlrd,ctypes


def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False


def get_case_mapping(path, sheetname):
    data = xlrd.open_workbook(path)
    table = data.sheet_by_name(sheetname)

    nrows = table.nrows
    ncols = table.ncols

    TESTID_IDX = 2
    CASENAME_IDX = 4 #Testcase name
    TESTSET_IDX = 5
    PRODUCT_IDX = 6
    TESTNAME_ALM_IDX = 7
    TESTCYCLE_IDX = 8

    case_mapper = {}

    for i in range(1, nrows):
        case_mapper[table.row_values(i)[CASENAME_IDX]] = {"testSet": table.row_values(i)[TESTSET_IDX],
                                                        "testCycle": table.row_values(i)[TESTCYCLE_IDX],
                                                        "product": table.row_values(i)[PRODUCT_IDX],
                                                        "testID":table.row_values(i)[TESTID_IDX]}
    return case_mapper

'''
def get_testSet_product_mapping(path):
    data = xlrd.open_workbook(path)
    table = data.sheet_by_name("Query2")

    nrows = table.nrows
    ncols = table.ncols

    TESTSET_IDX = 3
    TYPE_IDX = 2
    PRODUCT_IDX = 1

    testSet_prod_mapper = {}

    for i in range(1,nrows):
        testSet_prod_mapper[table.row_values(i)[TESTSET_IDX]] = {"type":table.row_values(i)[TYPE_IDX],"prod":table.row_values(i)[PRODUCT_IDX]}

    return testSet_prod_mapper

def get_case_mapping(path):
    case_testSet_mapper = get_case_testSet_mapping(path)
    testSet_product_mapper = get_testSet_product_mapping(path)

    case_mapper = {}

    for key in case_testSet_mapper.keys():
        testSet = case_testSet_mapper.get(key)
        if testSet in testSet_product_mapper.keys():
            case_mapper[key] = {"testSet":testSet,"type":testSet_product_mapper.get(testSet).get("type"),"prod":testSet_product_mapper.get(testSet).get("prod")}
        else:
            case_mapper[key] = {"testSet":testSet,"type":"unknown","prod":"unknown"}

    return case_mapper
'''