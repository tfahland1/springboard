/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com

Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */
SELECT *
FROM Facilities where membercost>0

/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT( name )
FROM Facilities
WHERE membercost =0

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT *
FROM Facilities
WHERE membercost >0
AND monthlymaintenance > 0.2 * membercost
/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */
 SELECT *
FROM Facilities
WHERE facid =1
OR facid =5

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */
SELECT name, monthlymaintenance, (
CASE WHEN monthlymaintenance <100
THEN 'cheap' WHEN monthlymaintenance >100
THEN 'expensive' END)cost
FROM Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */
SELECT firstname, surname, MAX( joindate ) AS "maxdate"
FROM `Members`

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT distinct f.name,members.firstname,members.surname
        FROM facilities as f inner join bookings on f.facid=bookings.facid
        inner join members on members.memid=bookings.memid where f.name like '%Tennis Court%'
        order by members.surname

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
select members.firstname,members.surname,facilities.name, 
        case when members.memid=0 then b.slots*facilities.guestcost 
        else b.slots*facilities.membercost
        end as 'cost'
        from bookings as b 
        inner join facilities on b.facid=facilities.facid
        inner join members on members.memid=b.memid
        where starttime like '%2012-09-14%' and cost>30
        order by cost desc

/* Q9: This time, produce the same result as in Q8, but using a subquery. */


/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
select facilities.name, sum(
        case when members.memid=0 then b.slots*facilities.guestcost 
        else b.slots*facilities.membercost
        end) as cost
        from bookings as b 
        inner join facilities on b.facid=facilities.facid
        inner join members on members.memid=b.memid
        group by facilities.name
        order by cost
/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */
select m.firstname, m.surname as person, r.firstname as recommendfirst,r.surname as recommendsur
        from members as m
        inner join members r
        on r.memid=m.recommendedby
        order by m.surname

/* Q12: Find the facilities with their usage by member, but not guests */
SELECT count(*), members.firstname,members.surname  from bookings as b
        inner join facilities on b.facid=facilities.facid
        inner join members on members.memid=b.memid
        where members.memid>0
        group by members.memid

/* Q13: Find the facilities usage by month, but not guests */
SELECT  count(*),strftime('%m', date(b.starttime)) as mm  from bookings as b
        inner join facilities on b.facid=facilities.facid
        inner join members on members.memid=b.memid
        where members.memid>0
        group by mm
