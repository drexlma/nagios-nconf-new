#!/usr/bin/python

import MySQLdb
import socket
import logging
import getpass

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')

fh = logging.FileHandler('epic-fails.log')
fh.setLevel(logging.DEBUG)
fh.setFormatter(formatter)
logger.addHandler(fh)

ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)
ch.setFormatter(formatter)
logger.addHandler(ch)


def main():
#    host = raw_input('Host: ')
#    user = raw_input('User: ')
#    password = getpass.getpass('Password: ')
#    db_name = raw_input('DB Name: ')
#    db = MySQLdb.connect(host, user, password, db_name)
    host="localhost";
    user="root";
    password="";
    db_name="nconf";
    db = MySQLdb.connect(host, user, password, db_name)
    cursor = db.cursor()
    cmd = "select * from  ConfigValues where fk_id_attr =79;"
    #cmd = "select * from ConfigValues"
    cursor.execute(cmd)
    results = cursor.fetchall()
    counter = 0
    for row in results:
        print row[0];
        print 444444;
      #  addr = row[0]
        if  "metrics-web.app.uj1.inmobi.com" in row[0]:
             print 55555555555555;
             newentry=row[0].replace("metrics-web.app.uj1.inmobi.com","app-metrics-web.app.uj1.inmobi.com");
             print newentry;
             try:
              cmd = "update ConfigValues set attr_value='%s' where attr_value='%s'" % (newentry, row[0])
              cursor.execute(cmd)
              db.commit()
       #     logger.debug('Something is still happening. Chill... B-)')
             except Exception as e:
              print e;
             
        #    logger.error('Lookup of %s failed.\n' % addr)
#            counter += 1
#        except:
#     #       logger.error('Failed to write to DB. Hostname: %s, Address: %s' % (hostname, addr))
#            db.rollback()
#            counter += 1
    #print 'Total Hostname Lookup Failures: %d' % counter


if __name__ == '__main__':
    main()
