----------------------------------------------------------------------------------------------------------------
-- question A
CREATE TABLE election (
    edate DATE NOT NULL,
    kno INT CHECK (kno > 0), -- kneset number must be 1 or more
    PRIMARY KEY (edate)
);

CREATE TABLE party (
    pname CHAR(20),
    symbol CHAR(5),
    PRIMARY KEY (pname)
);

CREATE TABLE running (
    edate DATE NOT NULL,    -- party must run at least once so edate can't be null
    pname CHARACTER(20),
    chid NUMERIC(5, 0),
    totalvotes INT DEFAULT 0,
    PRIMARY KEY (edate, pname),
    FOREIGN KEY (pname) REFERENCES party(pname),
    FOREIGN KEY (edate) REFERENCES election(edate)
);

CREATE TABLE city (
    cid NUMERIC(5,0),
    cname VARCHAR(20),
    region VARCHAR(20),
    PRIMARY KEY (cid)
);

CREATE TABLE votes (
    cid NUMERIC(5,0),
    pname CHARACTER(20),
    edate DATE NOT NULL,
    nofvotes INT NOT NULL CHECK (nofvotes > 0), 
    -- according to MAMAN 11 party wont apear with the city if it has no votes
    PRIMARY KEY (cid, pname, edate),
    FOREIGN KEY (pname) REFERENCES party(pname),
    FOREIGN KEY (edate) REFERENCES election(edate),
    FOREIGN KEY (cid) REFERENCES city(cid)
);

----------------------------------------------------------------------------------------------------------------
-- question B
CREATE OR REPLACE FUNCTION trigf1() -- trigger to update the totalvotes in running table
RETURNS TRIGGER AS $$
BEGIN
    UPDATE running
    SET totalvotes = totalvotes + NEW.nofvotes
    WHERE pname = NEW.pname AND edate = NEW.edate;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER T1
BEFORE INSERT OR UPDATE ON votes
FOR EACH ROW
EXECUTE FUNCTION trigf1();

----------------------------------------------------------------------------------------------------------------
-- question C
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

----------------------------------------------------------------------------------------------------------------
-- question D(1)
SELECT votes.pname, votes.nofvotes AS votes_in_ryde_end_2020_03_02
FROM votes, city
WHERE edate = '2020-03-02' AND cname = 'Ryde End'
    AND votes.cid = city.cid;

-- question D(2)
SELECT votes.pname AS party_ran_in_3rd_kneset, city.region, SUM (votes.nofvotes) AS totalnofvotes_in_region
FROM votes, city, election
WHERE kno = 3
    AND votes.cid = city.cid
    AND votes.edate = election.edate
GROUP BY votes.pname, city.region;

-- question D(3)
SELECT city.cname AS city_never_voted_life, city.region AS city_region
FROM city
-- cities that doen't exist int the following section didn't vote to life party:
WHERE NOT EXISTS (        
    SELECT *
    FROM votes
    WHERE votes.cid = city.cid 
        AND votes.pname = 'life party'
        -- cities that ***did*** vote to them
);

-- question D(4)
SELECT votes.edate AS max_running_parties_votesdate, election.kno AS kneset_number
FROM party, votes, election
WHERE votes.pname = party.pname
    AND votes.edate = election.edate
GROUP BY votes.edate, election.kno
HAVING COUNT(DISTINCT votes.pname) = (
    SELECT MAX(num_parties)
    FROM (
        SELECT COUNT(DISTINCT pname) AS num_parties
        FROM votes
        GROUP BY edate
    ) AS party_counts
);

-- question D(5)
-- no limit on the number of parties according to MAMAN 12 instructions
-- triyed to avoid "join" so didnt use the "totalvotes" column in running table
SELECT votes.pname AS party_ran_3rd_kno_and_no_hills_votes, MIN(votes.nofvotes) AS min_votes_in_the_group
FROM votes, election, running
WHERE votes.pname = running.pname
    AND votes.edate = election.edate
    AND running.edate = election.edate
    AND election.kno = 3
    AND NOT EXISTS (        
        SELECT *
        FROM city
        WHERE votes.cid = city.cid
            AND city.region = 'hills' 
        )
    AND votes.nofvotes = (
        SELECT MIN(nofvotes)
        FROM votes
        WHERE pname = votes.pname
    )
GROUP BY votes.pname;

-- question D(6)
SELECT votes.pname AS second_biggest_party_in_3rd_kneset
FROM votes, election
WHERE votes.edate = election.edate
    AND election.kno = 3
    AND votes.nofvotes = (
        SELECT MAX(votes.nofvotes) -- the second biggest party is the biggest among all *without the biggest one*
        FROM votes, election
        WHERE votes.edate = election.edate
            AND election.kno = 3
            AND votes.nofvotes < (  -- all the parties exept the biggest one
                SELECT MAX(votes.nofvotes)
                FROM votes, election
                WHERE votes.edate = election.edate
                    AND election.kno = 3
            )
    )
GROUP BY votes.pname;

-- question D(7)
SELECT DISTINCT v1.pname AS party1, v2.pname AS party2
FROM votes v1
JOIN votes v2 ON v1.edate = v2.edate AND v1.pname < v2.pname; -- used 'smaller than' to avoid duplicates