# Duncan Scott Martinson and John Payton
# Database Systems
# Dr. Lisa Ball
# HW4

#Imports
import sqlite3
from random import randint
#set up the db interaction
db = sqlite3.connect("simulation.db")
cursor = db.cursor()

#Constants
maxSimulations = 250
counter = 0
maxPath1 = 33
maxPath2 = 67
maxPath3 = 99
#initialize probability of choosing each path
path1Prob = 34
path2Prob = 33
path3Prob = 33

#clear the db
cursor.execute('''drop table if exists trigger''')

#main loop
while counter < maxSimulations:
#check if any of the probabilities are either 0 or 100, break if so
    if path1Prob == 100 or path1Prob == 0:
        break
    if path2Prob == 100 or path2Prob == 0:
        break
    if path3Prob == 100 or path3Prob == 0:
        break
#make a random choice number between 0 and 99
    choice = randint(0,99)

#determine which range the choice falls in
    if choice<=maxPath1:
        path1Prob = path1Prob + 2
        path2Prob = path2Prob - 1
        path3Prob = path3Prob - 1
    elif choice <= maxPath2:
        path2Prob = path2Prob + 2
        path1Prob = path1Prob - 1
        path3Prob = path3Prob - 1
    else:
        path3Prob = path3Prob + 2
        path1Prob = path1Prob - 1
        path2Prob = path2Prob - 1

#increment counter
    counter = counter+1

#for one line insert
paths = [('Do task now                  ',path1Prob,),
("I don't want to              ",path2Prob,),
("I'll never be able to do this",path3Prob,)]

#create the table
cursor.execute('''
create table trigger(path varchar(30), probability int)
''')
#insert the values
cursor.executemany('''insert into trigger values(?,?)''',paths)


#print the report
print("DB Systems Homework #4".center(40))
print("Duncan Scott Martinson and John Payton".center(40))
print()
print("Result of Stream of Thought Simulator".center(40))
print("Prompt: Task that needs to be done".center(40))
print("\n")

cursor.execute('''select * from trigger order by probability desc''')
rows = cursor.fetchall()

for row in rows:
    print("{:<10s}{:>10d}%".format(row[0],row[1]).center(40))

#close out
cursor.close()
db.commit()
db.close()
