import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QTabWidget, QRadioButton, QLineEdit, QTableView, QPushButton
from PyQt5 import uic
from PyQt5.QtCore import *
import psycopg2

#This is for casting 'Decimal(...)' values from PostgreSQL DB
DEC2FLOAT = psycopg2.extensions.new_type(
    psycopg2.extensions.DECIMAL.values,
    'DEC2FLOAT',
    lambda value, curs: float(value) if value is not None else None)
psycopg2.extensions.register_type(DEC2FLOAT)


class MainWindow(QMainWindow):
    def __init__(self):
        super(MainWindow, self).__init__()
        uic.loadUi('form.ui', self)
        self.cur = psycopg2.connect(database='hospital',
                                    user='nikitasmirnov',
                                    password='yanikita',
                                    host='10.90.137.100').cursor()
        self.tables = []
        self.buttons = []
        self.models = []
        for i in range(1,6):
            self.tables.append(self.findChild(QTableView, 'tableView_'+str(i)))
            self.buttons.append(self.findChild(QPushButton, 'queryButton'+str(i)))
            self.models.append(TableModel('SELECT * FROM query' + str(i) + ';', self.cur, self))
        for table, model in zip(self.tables, self.models):
            table.setModel(model)
        
    
    def ui(self):
        for index in range(len(self.buttons)):
            self.buttons[index].clicked.connect(self.tables[index].refresh)
        self.show()


class TableModel(QAbstractTableModel):
    def __init__(self, query, cursor, parent=None, *args):
        QAbstractTableModel.__init__(self, parent, *args)
        cursor.execute(query)
        self.arraydata = []
        for rec in cursor:
            self.arraydata.append(list(rec))
        self.headerdata = [desc[0] for desc in cursor.description]

    def rowCount(self, parent):
        return len(self.arraydata)

    def columnCount(self, parent):
        return len(self.arraydata[0])

    def data(self, index, role):
        if not index.isValid():
            return QVariant()
        elif role != Qt.DisplayRole:
            return QVariant()
        return QVariant(self.arraydata[index.row()][index.column()])
    
    def headerData(self, col, orientation, role):
        if orientation == Qt.Horizontal and role == Qt.DisplayRole:
            return QVariant(self.headerdata[col])
        return QVariant()


if __name__ == "__main__":
    app = QApplication([])
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())
