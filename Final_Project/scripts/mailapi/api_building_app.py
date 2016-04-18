from flask import Flask, request
from flask_restful import Resource, Api
from sqlalchemy import create_engine
from json import dumps
import psycopg2
import os

SQLALCHEMY_DATABASE_URI = "postgresql+psycopg2://w205:MIDS@localhost/dvdrental"
e = create_engine(SQLALCHEMY_DATABASE_URI)

app = Flask(__name__)
api = Api(app)

class Category(Resource):

  def get(self):
      # connect to the db
      conn = e.connect()
      # query the category table
      query = conn.execute("SELECT DISTINCT name FROM category;")
      print query
      result = {"categories": [i[0] for i in query.cursor.fetchall()]}
      print result
      return result

class Films(Resource):

  def get(self, category):
      conn = e.connect()
      # query the film table
      print category
      if category.upper() != "ALL":
        query = conn.execute("SELECT * FROM nicer_but_slower_film_list WHERE category = '%s';" % category)
      else:
        query = conn.execute("SELECT * FROM nicer_but_slower_film_list;")
      result = {"films": [{"id":i[0], "title":i[1], "description":i[2], "category":i[3], "price":str(i[4]), "rating":[6], "actors":[7]} \
                            for i in query.cursor.fetchall()]}
      print result
      return result

api.add_resource(Category, "/categories")
api.add_resource(Films, "/films/<string:category>")

if __name__ == '__main__':
    test_con = e.connect()
    test_query = "SELECT * FROM nicer_but_slower_film_list LIMIT 1;"
    test_result = test_con.execute(test_query)
    print test_result.cursor.fetchall()
    port = int(os.environ.get("PORT", 8080))
    app.run(host='0.0.0.0', port=port, debug=True)
