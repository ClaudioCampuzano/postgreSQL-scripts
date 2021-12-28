create or replace function logds_toinflux() 
	returns table (
		id_cc int,
  		id_ds int,
		fps character varying,
		fecha character varying,
		hora character varying,
		analitica character varying
	)
	language plpgsql
as $$
declare
	declare id_fin bigint;
begin
	SELECT lastlogconsulted.registro_id INTO id_fin FROM lastlogconsulted WHERE id=1;
		
	UPDATE lastlogconsulted 
	set registro_id=(
		SELECT registro_id 
		FROM log_ds 
		order by registro_id 
		desc limit 1) 
	where id=1;
	
	raise notice 'Value %', id_fin;
	
	RETURN QUERY SELECT 
	log_ds.id_cc, log_ds.id_ds, log_ds.fps, log_ds.fecha, log_ds.hora, log_ds.analitica
	FROM log_ds 
	WHERE registro_id > id_fin
	ORDER BY registro_id desc;
end;
$$

create or replace function logds_toinflux_1() 
	returns table (
		id_cc int,
  		id_ds int,
		fps character varying,
		marca_tiempo character varying,
		analitica character varying
	)
	language plpgsql
as $$
declare
	declare id_fin bigint;
begin
	SELECT lastlogconsulted.registro_id INTO id_fin FROM lastlogconsulted WHERE id=1;
		
	UPDATE lastlogconsulted 
	set registro_id=(
		SELECT registro_id 
		FROM log_ds 
		order by registro_id 
		desc limit 1) 
	where id=1;
		
	RETURN QUERY SELECT 
	log_ds.id_cc, 
	log_ds.id_ds, 
	log_ds.fps, 
	cast (CONCAT(log_ds.fecha, ' ', log_ds.hora) as character varying ) as marca_tiempo,
	log_ds.analitica
	FROM log_ds 
	WHERE registro_id > id_fin
	ORDER BY registro_id desc;
end;
$$

create or replace function logds_toinflux_1() 
	returns table (
		id_cc int,
  		id_ds int,
		fps character varying,
    	datetime timestamp with time zone,
		analitica character varying
	)
	language plpgsql
as $$
declare
	declare id_fin bigint;
begin
	SELECT lastlogconsulted.registro_id INTO id_fin FROM lastlogconsulted WHERE id=1;
		
	UPDATE lastlogconsulted 
	set registro_id=(
		SELECT registro_id 
		FROM log_ds 
		order by registro_id 
		desc limit 1) 
	where id=1;
		
	RETURN QUERY SELECT 
	log_ds.id_cc, 
	log_ds.id_ds, 
	log_ds.fps, 
	to_timestamp(concat(log_ds.fecha, ' ', log_ds.hora), 'DD-MM-YYYY HH24:MI:SS') as datetime,
	log_ds.analitica
	FROM log_ds 
	WHERE registro_id > id_fin
	ORDER BY registro_id desc;
end;
$$

DROP FUNCTION logds_toinflux();

select * from logds_toinflux();
