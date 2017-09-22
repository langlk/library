#!/usr/bin/env ruby

require "pg"

control = PG.connect(dbname: "postgres")
control.exec('CREATE DATABASE library;')
db = PG.connect(dbname: "library")
db.exec("CREATE TABLE books (id serial PRIMARY KEY, title varchar, author_first varchar, author_last varchar, checked_in boolean);")
db.exec("CREATE TABLE patrons (id serial PRIMARY KEY, first_name varchar, last_name varchar);")
db.exec("CREATE TABLE checkouts (id serial PRIMARY KEY, book_id int, patron_id int, checkout_date date, due_date date, checked_in boolean);")
db.exec("CREATE TABLE users (id serial PRIMARY KEY, patron_id int, email varchar, username varchar, password varchar, admin boolean);")
db.exec("CREATE DATABASE library_test WITH TEMPLATE library;")
