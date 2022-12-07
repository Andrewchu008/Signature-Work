-- Databricks notebook source
select * from athlete_events;

-- COMMAND ----------

select * from noc;

-- COMMAND ----------

-- Total medal count per country

select noc,
sum(case when medal='Gold' then 1 else 0 end) as gold_count,
sum(case when medal='Silver' then 1 else 0 end) as silver_count,
sum(case when medal='Bronze' then 1 else 0 end) as bronze_count
from athlete_events
group by noc
order by gold_count desc;

-- COMMAND ----------

-- total gold, silver and broze medals won by each country corresponding to each olympic games

select noc,games,
sum(case when medal='Gold' then 1 else 0 end) as gold_count,
sum(case when medal='Silver' then 1 else 0 end) as silver_count,
sum(case when medal='Bronze' then 1 else 0 end) as bronze_count
from athlete_events
group by noc,games
order by gold_count desc

-- COMMAND ----------

-- display which country won the most gold, silver, and bronze medals in each olympic games

with final_t as (select noc,games,
sum(case when medal='Gold' then 1 else 0 end) as gold_count,
sum(case when medal='Silver' then 1 else 0 end) as silver_count,
sum(case when medal='Bronze' then 1 else 0 end) as bronze_count
from athlete_events
group by noc,games
order by games desc),
t1 as(select games,max(gold_count) g, max(silver_count) s,max(bronze_count ) b
from final_t
group by games
order by games),

gold as(
select t.games, concat(t.g, '-',f.noc) as Gold_Max
from final_t f , t1 t
where f.gold_count= t.g and f.games=t.games ),

silver as (select t.games,concat(t.s,'-',f.noc) as Silver_Max
from final_t f , t1 t
where f.silver_count= t.s and f.games=t.games ),

bronze as (select t.games, concat(t.b,'-',f.noc) as Bronze_Max
from final_t f , t1 t
where f.bronze_count= t.b and f.games=t.games )

select gl.games,Gold_Max, Silver_max,Bronze_max
from gold gl, silver sl,bronze bl
where gl.games=sl.games and sl.games=bl.games and bl.games= gl.games
order by gl.games

-- COMMAND ----------

-- display which sport USA has won highest medals.

with t1 aS
  (select sport, count(1) as total_medals
  from athlete_events
  where medal <> 'NA'
  and team = 'United States'
  group by sport
  order by total_medals desc),
  t2 as
    (select *, rank() over(order by total_medals desc) as rnk
        	from t1)
    select sport, total_medals
    from t2
    where rnk = 1;

-- COMMAND ----------


