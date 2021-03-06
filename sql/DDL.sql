-------------------sql-functions------------------------


CREATE OR REPLACE FUNCTION public.adddeliverydata(name character varying, phone character varying, zip character varying, city character varying, address character varying, region character varying, email character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
		insert into delivery (name,phone,zip,city,address,region,email)
		values (name,phone,zip,city,address,region,email);
$function$
;


CREATE OR REPLACE FUNCTION public.additemdata(order_id character varying, chrt_id bigint, track_number character varying, price integer, rid character varying, name character varying, sale integer, size character varying, total_price integer, nm_id integer, brand character varying, status integer)
 RETURNS void
 LANGUAGE sql
AS $function$
	insert into items (order_uid,chrt_id,track_number,price,rid,name,sale,size,total_price,nm_id,brand,status)
	values (order_id,chrt_id,track_number,price,rid,name,sale,size,total_price,nm_id,brand,status);
$function$
;


CREATE OR REPLACE FUNCTION public.addorderdata(order_uid character varying, track_number character varying, entry character varying, payment character varying, locale character varying, internal_signature character varying, customer_id character varying, delivery_service character varying, shardkey character varying, sm_id integer, date_created date, oof_shard character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
	insert into "order"(order_uid, track_number,entry,delivery_to,payment,locale,internal_signature,
	customer_id, delivery_service,shardkey,sm_id,date_created,oof_shard)
	values (order_uid, track_number,entry, (select MAX(id) from delivery), payment, locale, 
	internal_signature, customer_id, delivery_service, shardkey, sm_id, date_created, oof_shard);
$function$
;


CREATE OR REPLACE FUNCTION public.addpaymentdata(transaction character varying, request_id character varying, currency character varying, provider character varying, amount integer, payment_dt bigint, bank character varying, delivery_cost integer, goods_total integer, custom_fee integer)
 RETURNS void
 LANGUAGE sql
AS $function$
		insert into payment  (transaction , request_id,currency,provider,amount,payment_dt,bank,delivery_cost,goods_total,custom_fee)
		values (transaction , request_id,currency,provider,amount,payment_dt,bank,delivery_cost,goods_total,custom_fee);
$function$
;

------------------------------------------------------------------


--------------------------tables----------------------------------
CREATE TABLE public.delivery (
	phone varchar NOT NULL,
	zip varchar NOT NULL,
	city varchar NOT NULL,
	address varchar NOT NULL,
	region varchar NOT NULL,
	email varchar NOT NULL,
	"name" varchar NOT NULL,
	id serial4 NOT NULL,
	CONSTRAINT delivery_pk PRIMARY KEY (id)
);
ALTER TABLE public.delivery ADD CONSTRAINT delivery_pk PRIMARY KEY (id);




CREATE TABLE public.items (
	order_uid varchar NOT NULL,
	chrt_id int8 NOT NULL,
	track_number varchar NOT NULL,
	price int4 NOT NULL,
	rid varchar NOT NULL,
	"name" varchar NOT NULL,
	sale int4 NOT NULL,
	"size" varchar NOT NULL,
	total_price int4 NOT NULL,
	nm_id int4 NOT NULL,
	brand varchar NOT NULL,
	status int4 NOT NULL
);


-- public.items foreign keys

ALTER TABLE public.items ADD CONSTRAINT items_to_order FOREIGN KEY (order_uid) REFERENCES public."order"(order_uid) ON DELETE SET DEFAULT;




CREATE TABLE public."order" (
	order_uid varchar NOT NULL,
	track_number varchar NOT NULL,
	entry varchar NOT NULL,
	delivery_to int4 NOT NULL,
	payment varchar NOT NULL,
	locale varchar NOT NULL,
	internal_signature varchar NULL,
	customer_id varchar NOT NULL,
	delivery_service varchar NOT NULL,
	shardkey varchar NOT NULL,
	sm_id int4 NOT NULL,
	date_created date NOT NULL,
	oof_shard varchar NOT NULL,
	CONSTRAINT order_pk PRIMARY KEY (order_uid)
);


-- public."order" foreign keys

ALTER TABLE public."order" ADD CONSTRAINT order_to_delivery FOREIGN KEY (delivery_to) REFERENCES public.delivery(id);
ALTER TABLE public."order" ADD CONSTRAINT order_to_payment FOREIGN KEY (payment) REFERENCES public.payment("transaction");
ALTER TABLE public."order" ADD CONSTRAINT order_pk PRIMARY KEY (order_uid);





CREATE TABLE public.payment (
	"transaction" varchar NOT NULL,
	request_id varchar NULL,
	currency varchar NOT NULL,
	provider varchar NOT NULL,
	amount int4 NOT NULL,
	payment_dt int8 NOT NULL,
	bank varchar NOT NULL,
	delivery_cost int4 NOT NULL,
	goods_total int4 NOT NULL,
	custom_fee int4 NOT NULL,
	CONSTRAINT payment_pk PRIMARY KEY (transaction)
);
ALTER TABLE public.payment ADD CONSTRAINT payment_pk PRIMARY KEY (transaction);
