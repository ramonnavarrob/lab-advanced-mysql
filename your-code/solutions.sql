use publications;
SELECT `title_id`, qty from sales;
select title_id, price, royalty from titles;
select title_id ,au_id, royaltyper from titleauthor;

SELECT `titleauthor`.`au_id`, SUM(`titleauthor`.`royaltyper`/100 * `titles`.`price` * `titles`.`royalty`/100 * `sales`.`qty`) AS `TOTAL ROYALTIES`
FROM titleauthor
LEFT JOIN titles ON titles.`title_id` = titleauthor.`title_id`
LEFT JOIN sales ON sales.`title_id` = titleauthor.`title_id`
GROUP BY titleauthor.`au_id`;

SELECT titleauthor.`au_id`, SUM((titles.`advance` + sales.qty * titles.price * titles.royalty/100) * titleauthor.royaltyper/100) AS `TOTAL ROYALTIES`
FROM titleauthor
LEFT JOIN titles ON titles.`title_id` = titleauthor.`title_id`
LEFT JOIN sales ON sales.`title_id` = titleauthor.`title_id`
GROUP BY titleauthor.`au_id`
ORDER BY `TOTAL ROYALTIES` DESC;



#Excercise1-codealongDAY4
CREATE TEMPORARY TABLE tot_toy_adv_per_title_auth
select 
	s.title_id, 
	s.qty,
	t.price, 
	t.royalty, 
	t.advance,
	ta.royaltyper,
	ta.au_id,
	s.qty * t.price * t.royalty/100 * ta.royaltyper/100 as tot_roy,
	t.advance * ta.royaltyper/100 as tot_adv
from 
	sales s
		left join 
	titles t on s.title_id = t.title_id
		left join 
	titleauthor ta on t.title_id = ta.title_id;

#temporary table exercise1	
CREATE TEMPORARY TABLE tortoise
SELECT 
	au_id, 
	title_id, 
	sum(tot_roy) sum_tot_roy, 
	avg(tot_adv) tot_adv_ta
from tot_toy_adv_per_title_auth
group by au_id, title_id;


#second temporary table excercise1
CREATE TEMPORARY TABLE jellyfish
SELECT
	au_id,
	sum(sum_tot_roy) as roy,
	sum(tot_adv_ta) as adv
FROM tortoise
group by au_id;

SELECT 
	au_id,
	roy + adv as total_profit from jellyfish; 
