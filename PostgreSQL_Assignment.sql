select * from rangers;
select * from species;
select * from sightings;

create table "rangers"(
    "ranger_id" serial primary key not null,
    "name" VARCHAR(100),
    "region" VARCHAR(100)
)

insert into rangers values(1, ' Alice Green', 'Northern Hills'), 
(2,  'Bob White', 'River Delta'), 
(3, 'Carol King', 'Mountain Range');


create table "species"(
    "species_id" serial primary key not null,
    "common_name" VARCHAR(100),
    "scientific_name" VARCHAR(100),
    "discovery_date" DATE,
    "conservation_status" VARCHAR(100)
)


insert into "species" values(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable' ),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');


create table "sightings" (
    "sighting_id" SERIAL PRIMARY KEY,
    "ranger_id" INT REFERENCES rangers(ranger_id) ON DELETE SET NULL,
    "species_id" INT REFERENCES species(species_id) ON DELETE SET NULL,
    "location" VARCHAR(100),
    "sighting_time" TIMESTAMP,
    "notes" TEXT
);

INSERT INTO "sightings"(sighting_id, ranger_id, species_id, location, sighting_time, notes)
VALUES 
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 4, 4, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

-- Problem 1
insert into rangers(name, region) values('Derek Fox', 'Coastal Plains');

-- Problem 2
select count(*) as "unique_species_count" from species where conservation_status = 'Endangered';


-- Problem 3
select * from sightings where location LIKE('%Pass%');

-- Problem 4
select "name", count(*) as "total_sightings" from rangers group by "name";

-- Problem 5
select common_name from species where species_id not in(select distinct species_id from sightings);

-- Problem 6
select species.common_name, sightings.sighting_time, rangers.name
from sightings 
join species on sightings.species_id = species.species_id
join rangers on sightings.ranger_id = rangers.ranger_id
where sightings.sighting_time >= '2024-05-01' and sightings.sighting_time < NOW()
order by sightings.sighting_time desc 
limit 2;

-- Problem 7
update species set conservation_status = 'Historic' where discovery_date < '1800-01-01';

-- Problem 8
select sighting_id, 
case
when extract(hour from sighting_time) < 12 then 'Morning'
when extract(hour from sighting_time) >= 12 and extract(hour from sighting_time) < 17 then 'Afternoon'
else 'Evening'end as time_of_day from sightings;


--Problem 9
delete from rangers where ranger_id not in(select distinct ranger_id from sightings);
