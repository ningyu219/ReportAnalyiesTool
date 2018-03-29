#coding=utf-8

'''
测试python驱动
'''

#引用对应的包
import pymongo

#创建一个mongo客户端对象
client = pymongo.MongoClient("127.0.0.1",27017)
#获得mongoDB中的数据库对象
db = client.test_database
#在数据库中创建一个集合
collection = db.test_collectionTwo

#创建一条要加入数据库中的数据信息,json格式
post_data = {"username":"xiaohao","pwd":"123456",}

#进行数据的添加操作,inserted_id返回添加后的id编号信息
post_data_id = collection.insert_one(post_data).inserted_id

#展示一下插入的数据信息
print collection.find_one()

#打印当前数据库中所有集合的民称
print db.collection_names()

#打印当前集合中数据的信息
for item in collection.find():
    print item

#打印当前集合中数据的个数
print collection.count()

#进行find查询，并打印查询到的数据的条数
print collection.find({"username":"xiaohao"}).count()