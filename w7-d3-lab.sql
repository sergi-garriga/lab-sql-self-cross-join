use sakila;



-- 1. Get all pairs of actors that worked together.
select * from film_actor;
 
select a.actor_id as actor_1, b.actor_id as actor_2 from film_actor a
join film_actor b on a.film_id = b.film_id
where a.actor_id <> b.actor_id;







-- 2.Get all pairs of customers that have rented the same film more than 3 times.
select * from rental; -- r
select * from inventory; -- i

	-- query: we need to know how many times each costumer has rented each film
select r.customer_id, i.film_id, count(rental_id) as times_movie_rented_by_client
from rental r
left join inventory i using(inventory_id)
group by customer_id, film_id
order by customer_id;

	-- self join the previous query to see pairs of customers that have rented the same film
select 	t1.customer_id as customer_1, t1.film_id, t1.times_movie_rented_by_client, 
		t2.customer_id as customer_2, t2.film_id, t2.times_movie_rented_by_client
	from (
	select r.customer_id, i.film_id, count(r.rental_id) as times_movie_rented_by_client
	from rental r
	left join inventory i using(inventory_id)
	group by customer_id, film_id
	order by customer_id
    )t1
left join(
	select r.customer_id, i.film_id, count(r.rental_id) as times_movie_rented_by_client
	from rental r
	left join inventory i using(inventory_id)
	group by customer_id, film_id
	order by customer_id
    )t2
on	t1.film_id = t2.film_id -- same film
and t1.customer_id < t2.customer_id; -- avoid duplicates

	-- here we select the pairs of customers whose sum of times_movie_rented_by_client is >3
select 	customer_1,
		customer_2,
        film_id_1 as film_id,
		rentals_1 + rentals_2 as times_rented_by_pair
from (
	select 	t1.customer_id as customer_1, t1.film_id as film_id_1, t1.times_movie_rented_by_client as rentals_1, 
			t2.customer_id as customer_2, t2.film_id as film_id_2, t2.times_movie_rented_by_client as rentals_2
	from (
		select r.customer_id, i.film_id, count(r.rental_id) as times_movie_rented_by_client
		from rental r
		left join inventory i using(inventory_id)
		group by customer_id, film_id
		order by customer_id
		)t1
	left join(
		select r.customer_id, i.film_id, count(r.rental_id) as times_movie_rented_by_client
		from rental r
		left join inventory i using(inventory_id)
		group by customer_id, film_id
		order by customer_id
		)t2
	on	t1.film_id = t2.film_id
	and t1.customer_id < t2.customer_id
	)sub
where rentals_1 + rentals_2 > 3;







-- 3.Get all possible pairs of actors and films.
select * from actor;
select * from film_actor;

select * from (
select distinct first_name, last_name from actor
) sub1
cross join (
select title from film
) sub2; 




