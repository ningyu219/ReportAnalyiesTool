import json
from utils.xmltodict import xmltodict
from utils.xmltodict.xmltodict import parse

if __name__ == "__main__":
    print(json.dumps(xmltodict.parse("""
      <mydocument has="an attribute">
        <and>
          <many>elements</many>
          <many>more elements</many>
        </and>
        <plus a="complex">
          element as well
        </plus>
      </mydocument>
      """), indent=4))