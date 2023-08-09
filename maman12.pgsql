DROP TABLE IF EXISTS election, party, city, runing, running, votes CASCADE;

CREATE TABLE election (
    edate DATE,
    kno INT,
    PRIMARY KEY (edate)
);

CREATE TABLE party (
    pname CHAR(20),
    symbol CHAR(5),
    PRIMARY KEY (pname)
);

CREATE TABLE city (
    cid NUMERIC(5,0),
    cname VARCHAR(20),
    region VARCHAR(20),
    PRIMARY KEY (cid)
);

CREATE TABLE running (
    edate DATE,
    pname CHARACTER(20),
    chid NUMERIC(5, 0),
    totalvotes INT,
    PRIMARY KEY (edate, pname),
    FOREIGN KEY (pname) REFERENCES party(pname),
    FOREIGN KEY (edate) REFERENCES election(edate)
);

CREATE TABLE votes (
    cid NUMERIC(5,0),
    pname CHARACTER(20),
    edate DATE,
    nofvotes INT,
    PRIMARY KEY (cid, pname, edate),
    FOREIGN KEY (pname) REFERENCES party(pname),
    FOREIGN KEY (edate) REFERENCES election(edate),
    FOREIGN KEY (cid) REFERENCES city(cid)
);


INSERT INTO election (edate, kno) VALUES 
    ('2019-04-09', 1),
    ('2019-09-17', 2),
    ('2020-03-02', 3),
    ('2021-03-23', 4),
    ('2022-11-01', 5);

INSERT INTO party (pname, symbol) VALUES 
    ('nature party', 'np'),
    ('science group', 'sg'),
    ('life party', 'lp'),
    ('art group', 'ag'),
    ('lost group', 'lg'),
    ('cool party', 'cp');

INSERT INTO city (cid, cname, region) VALUES 
    (22, 'Ryde End', 'north'),
    (77, 'East Strat', 'south'),
    (33, 'Grandetu', 'center'),
    (88, 'Royalpre', 'hills'),
    (11, 'Carlpa', 'hills'),
    (44, 'Lommont', 'north'),
    (66, 'Grand Sen', 'south'),
    (99, 'Kingo Haven', 'hills'),
    (55, 'El Munds', 'south');

INSERT INTO running (edate, pname, chid) VALUES 
    ('2019-04-09', 'nature party', 12345),
    ('2019-04-09', 'life party', 54321),
    ('2019-04-09', 'lost group', 34567),
    ('2019-09-17', 'lost group', 76543),
    ('2019-09-17', 'art group', 67890),
    ('2020-03-02', 'science group', 90876),
    ('2020-03-02', 'nature party', 55555),
    ('2020-03-02', 'life party', 54321),
    ('2020-03-02', 'cool party', 11111);
    
INSERT INTO votes (cid, pname, edate, nofvotes) VALUES 
    (22, 'nature party', '2020-03-02', 100),
    (22, 'science group', '2020-03-02', 30),
    (22, 'life party', '2020-03-02', 500),
    (44, 'life party', '2020-03-02', 1000),
    (44, 'science group', '2020-03-02', 200),
    (44, 'nature party', '2020-03-02', 1000000),
    (77, 'nature party', '2020-03-02', 300),
    (77, 'science group', '2020-03-02', 150),
    (77, 'life party', '2020-03-02', 25),
    (33, 'nature party', '2020-03-02', 13),
    (33, 'science group', '2020-03-02', 740),
    (33, 'life party', '2020-03-02', 670),
    (33, 'cool party', '2020-03-02', 13);


SELECT * FROM election;
SELECT * FROM party;
SELECT * FROM city;
SELECT * FROM running;
SELECT * FROM votes;
