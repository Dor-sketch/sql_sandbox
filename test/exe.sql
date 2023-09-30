-- Import garden.db
\i garden.db

-- 3.1 all plants in db
select pname
from plant;

-- 3.2 all fruits trees in db
select pname
from plant
where ptype = 'עץ פרי';

-- for hebrew text just paste the line - evenn though it looks wrong direction in terminal


-- 3.3 combining tables
-- places where planting 'חרוב מצוי'
select area.alocation
from area, plant, plantingmap
where plant.pname = 'חרוב מצוי'
    and plant.pname = plantingmap.pname
    and plantingmap.aname = area.aname;


-- 3.4 naming the columns
-- list all the fruits trees but name the column 'fruit_trees'
select pname as fruit_trees
from plant
where ptype = 'עץ פרי';


-- 3.5 math expressions in the select
-- find the minimum area size that is required for planting 20 'חרוב מצוי'
select (20*3.14*pdiameter*pdiameter/4) as space_for_20_carob
from plant
where pname = 'חרוב מצוי';

-- 3.6 naming relation as a line variable
-- fint aname (חלקות) that have at least 2 different plants types
select p1.aname
from plantingmap as p1, plantingmap as p2
where p1.aname = p2.aname
    and p1.pname <> p2.pname;

-- 3.7 string matching
-- find the names of all the trees (עצי נו או עצי פרי)
select pname 
from plant
where ptype like '%עץ%';

-- 3.8 order by
-- list all the bushes and their hifhr ordered by deceasing height
-- from max to min
select pname, pmaxheight
from plant
where ptype = 'שיח'
order by pmaxheight desc;

-- 3.9 list all the anames ordered by ascending names
--      in each one list all the plants and the max hihgt o fthe plant ordered by deceasing height
select m.aname, m.pname, pmaxheight
from plantingmap as m, plant
where m.pname = plant.pname
order by m.aname asc, pmaxheight desc;

-- 3.10 using distinct to avoid duplicates
-- list all anmes - first with duplicates and then without
select aname
from plantingmap;

select distinct aname
from plantingmap;


-- operations on sets
-- intersection - find the anames that have both 'חרוב מצוי' and 'אלון תבל'
-- union - find the anames that have either 'חרוב מצוי' or 'אלון תבל'
-- except - find the anames that have 'חרוב מצוי' but not 'אלון תבל'

-- 3.11 using union to combine tables
-- find the names of all the trees (עצי נוי או עצי פרי)
-- in sqlite unin, intersect and except should be in brackets ()!
select pname
from plant
where ptype = 'עץ פרי'
union
(select pname
from plant
where ptype = 'עץ נוי');

-- 3.12 using except to find plants that are not trees
select pname
from plant
except
select pname
from plant
where ptype like '%עץ%';

-- instead of "like" we can use "or"
select pname
from plant
except
select pname
from plant
where ptype = 'עץ פרי'
    or ptype = 'עץ נוי';



-- null values
-- we can use is null or is not null to check if a value is null


-- groups operations in the select:
-- count() - count the number of rows in the group
-- min() - find the minimum value in the group
-- max() - find the maximum value in the group
-- sum() - sum all the values in the group
-- avg() - find the average value in the group

-- 3.13 find the max height of all the plants
select max(pmaxheight)
from plant;

-- 3.14 find the number of anames that have plants
-- WRONG - because multiple anames aload in plantingmap
select count(aname)
from plantingmap;

-- FIX 1 - using distinct
select count(distinct aname)
from plantingmap;

-- FIX 2 - using AREA table becuase it has unique anames
-- anames is a key in area table so it is unique
select count(aname)
from area;

-- 3.15 find the number of anames that their area is bigger than 2000
select count(aname)
from area
where asize > 2000;


-- group by
-- 3.16 find the number of plants in each type
select ptype, count(pname) as num_of_plants
from plant
group by ptype;


-- combining where and group by
-- 3.17 how many plants that their max height is bigger than 1 are in each plant type

