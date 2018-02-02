import cx_Oracle
import sys
import urllib
import os

db = cx_Oracle.connect('QART', 'qart', 'slcg60-scan1.us.oracle.com:1521')