import MySQLdb
import argparse

HOST = '127.0.0.1'
PORT = 3306
USERNAME = 'test'
PASSWORD = 'test'

class App(object):
    def __init__(self):
        try:
            self.connection = MySQLdb.connect(host=HOST, port=PORT, user=USERNAME, passwd=PASSWORD, charset='utf8')
            self.curs = self.connection.cursor()
        except Exception as e:
            print e
    def select_db(self, db_name):
        self.connection.select_db(db_name)

    def query(self, query_model, args_list):
        result_tuple = tuple()
        if query_model == '1':
            result_tuple = self._function_1(args_list)
        self.print_result(result_tuple)

    def print_result(self, result_tuple):
        for line in result_tuple:
            temp_list = []
            for item in line:
                if type(item) != type(u'1') :
                    temp_list.append(unicode(item))
                else:
                    temp_list.append(item)
            print '\t'.join(temp_list)

    def _query(self, sql_centence):
        self.curs.execute(sql_centence)
        return self.curs.fetchall()

    def commit_query(self):
        self.connection.commit()

    def __del__(self):
        self.curs.close()
        self.connection.close()

    def _function_1(self, args_list):
        _sql_templates = \
        '''
        SELECT DISTINCT employee.essn
        FROM employee
        JOIN works_on ON employee.essn = works_on.essn
        JOIN project ON project.pno = works_on.pno
        WHERE project.pno='%s';
        '''
        sql = _sql_templates % tuple(args_list)
        return self._query(sql)
    def _function_2(self, args_list):
        _sql_templates = \
        '''
        SELECT DISTINCT employee.ename
        FROM employee
        JOIN works_on ON employee.essn = works_on.essn
        JOIN project ON project.pno = works_on.pno
        WHERE project.pname='%s';
        '''

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-q', default='')
    parser.add_argument('-p', nargs='*')

    args_console = parser.parse_args()
    query_model = args_console.q
    query_args_list = args_console.p

    app = App()
    app.select_db('company')
    app.query(query_model, query_args_list)
