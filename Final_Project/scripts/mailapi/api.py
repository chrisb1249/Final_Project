from flask import Flask, request
from flask_restful import Resource, Api
from sqlalchemy import create_engine
from json import dumps
import psycopg2
import os

SQLALCHEMY_DATABASE_URI = "postgresql+psycopg2://postgres:MIDS@localhost/maildb"
e = create_engine(SQLALCHEMY_DATABASE_URI)

app = Flask(__name__)
api = Api(app)

class Stats(Resource):

  def get(self, lettershop):
      # connect to the db
      conn = e.connect()
      # query the category table
      query = conn.execute("SELECT state, averagepostal, stdevpostal FROM lsstate WHERE lettershop = '%s' ORDER BY STATE;" % lettershop )
      print query
      result = {"stats": [{"state":i[0], "average_postal_delivery":i[1], "standard_deviation":i[2]} for i in query.cursor.fetchall()]}
      print result
      return result

class Fastest(Resource):

  def get(self, state):
      conn = e.connect()
      query = conn.execute("SELECT lettershop, cnt, averagepostal FROM lsstate WHERE state = '%s' ORDER BY averagepostal LIMIT 1" % state )
      print query
      result = {"fastest": [{"lettershop":i[0], "quantity":i[1], "average_postal_delivery":i[2]} for i in query.cursor.fetchall()]}
      print result
      return result

class StateStat(Resource):

  def get(self, state):
      conn = e.connect()
      query = conn.execute("SELECT lettershop, cnt, averagepostal FROM lsstate where state = '%s' GROUP BY lettershop, cnt, averagepostal ORDER BY averagepostal" % state )
      print query
      result = {"statestat": [{"lettershop":i[0], "quantity":i[1], "average_postal_delivery":i[2]} for i in query.cursor.fetchall()]}
      print result
      return result

api.add_resource(Stats, "/stats/<string:lettershop>")
api.add_resource(Fastest, "/fastest/<string:state>")
api.add_resource(StateStat, "/statestat/<string:state>")

if __name__ == '__main__':
    test_con = e.connect()
    test_query = "SELECT * FROM lsstate LIMIT 1;"
    test_result = test_con.execute(test_query)
    print test_result.cursor.fetchall()
    port = int(os.environ.get("PORT", 8080))
    app.run(host='0.0.0.0', port=port, debug=True)
