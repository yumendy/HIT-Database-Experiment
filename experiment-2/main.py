# coding: utf8
import MySQLdb
import argparse

HOST = '127.0.0.1'
PORT = 3306
USERNAME = 'test'
PASSWORD = 'test'

class App(object):

    # 参加了项目编号为%PNO%的项目的员工号
    _sql_templates_1 = \
    '''
    SELECT DISTINCT employee.essn
    FROM employee
    JOIN works_on ON employee.essn = works_on.essn
    JOIN project ON project.pno = works_on.pno
    WHERE project.pno='%s';
    '''

    # 参加了项目名为%PNAME%的员工名字
    _sql_templates_2 = \
    '''
    SELECT DISTINCT employee.ename
    FROM employee
    JOIN works_on ON employee.essn = works_on.essn
    JOIN project ON project.pno = works_on.pno
    WHERE project.pname='%s';
    '''

    # 在%DNAME%工作的所有工作人员的名字和地址
    _sql_templates_3 = \
    '''
    '''






    def __init__(self):
        try:
            self.connection = MySQLdb.connect(host=HOST, port=PORT, user=USERNAME, passwd=PASSWORD, charset='utf8')
            self.curs = self.connection.cursor()
        except Exception as e:
            print e
    def select_db(self, db_name):
        self.connection.select_db(db_name)

    def query(self, query_model, args_list):
        result_tuple = self._fill_template(query_model, args_list)
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

    def _fill_template(self, q, args_list):
        sql = self.__getattribute__('_sql_templates_' + str(q)) % tuple(args_list)
        return self._query(sql)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-q', default='')
    parser.add_argument('-p', nargs='*')

    args_console = parser.parse_args()
    query_model = args_console.q
    query_args_list = args_console.p
    query_args_list = map(lambda item: item.decode('gbk'), query_args_list)

    app = App()
    app.select_db('company')
    app.query(query_model, query_args_list)
