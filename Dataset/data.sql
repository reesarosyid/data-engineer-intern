--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.10
-- Dumped by pg_dump version 9.6.10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: _dbo_account; Type: TABLE; Schema: public; Owner: current_user
--

CREATE TABLE public._dbo_account (
    account_id smallint,
    customer_id smallint,
    account_type character varying(8) DEFAULT NULL::character varying,
    balance integer,
    date_opened character varying(19) DEFAULT NULL::character varying,
    status character varying(10) DEFAULT NULL::character varying
);


ALTER TABLE public._dbo_account OWNER TO current_user;

--
-- Name: _dbo_branch; Type: TABLE; Schema: public; Owner: current_user
--

CREATE TABLE public._dbo_branch (
    branch_id smallint,
    branch_name character varying(12) DEFAULT NULL::character varying,
    branch_location character varying(23) DEFAULT NULL::character varying
);


ALTER TABLE public._dbo_branch OWNER TO current_user;

--
-- Name: _dbo_city; Type: TABLE; Schema: public; Owner: current_user
--

CREATE TABLE public._dbo_city (
    city_id smallint,
    city_name character varying(17) DEFAULT NULL::character varying,
    state_id smallint
);


ALTER TABLE public._dbo_city OWNER TO current_user;

--
-- Name: _dbo_customer; Type: TABLE; Schema: public; Owner: current_user
--

CREATE TABLE public._dbo_customer (
    customer_id smallint,
    customer_name character varying(15) DEFAULT NULL::character varying,
    address character varying(23) DEFAULT NULL::character varying,
    city_id smallint,
    age smallint,
    gender character varying(6) DEFAULT NULL::character varying,
    email character varying(16) DEFAULT NULL::character varying
);


ALTER TABLE public._dbo_customer OWNER TO current_user;

--
-- Name: _dbo_state; Type: TABLE; Schema: public; Owner: current_user
--

CREATE TABLE public._dbo_state (
    state_id smallint,
    state_name character varying(15) DEFAULT NULL::character varying
);


ALTER TABLE public._dbo_state OWNER TO current_user;

--
-- Name: _dbo_sysdiagrams; Type: TABLE; Schema: public; Owner: current_user
--

CREATE TABLE public._dbo_sysdiagrams (
    name character varying(9) DEFAULT NULL::character varying,
    principal_id smallint,
    diagram_id smallint,
    version smallint,
    definition character varying(58376) DEFAULT NULL::character varying
);


ALTER TABLE public._dbo_sysdiagrams OWNER TO current_user;

--
-- Name: _dbo_transaction_db; Type: TABLE; Schema: public; Owner: current_user
--

CREATE TABLE public._dbo_transaction_db (
    transaction_id smallint,
    account_id smallint,
    transaction_date character varying(19) DEFAULT NULL::character varying,
    amount integer,
    transaction_type character varying(10) DEFAULT NULL::character varying,
    branch_id smallint
);


ALTER TABLE public._dbo_transaction_db OWNER TO current_user;

--
-- Data for Name: _dbo_account; Type: TABLE DATA; Schema: public; Owner: current_user
--

INSERT INTO public._dbo_account (account_id, customer_id, account_type, balance, date_opened, status) VALUES
(1, 1, 'saving', 1500000, '2020-05-01 09:00:00', 'active'),
(2, 2, 'saving', 500000, '2020-06-01 10:00:00', 'active'),
(3, 1, 'checking', 25000000, '2020-06-21 09:00:00', 'active'),
(4, 3, 'checking', 4500000, '2021-06-24 11:00:00', 'terminated'),
(5, 4, 'saving', 75000000, '2020-06-29 13:00:00', 'active'),
(6, 5, 'checking', 1500000, '2020-07-01 09:00:00', 'active'),
(7, 6, 'saving', 15000000, '2020-07-14 09:00:00', 'terminated'),
(8, 7, 'checking', 25000000, '2020-07-15 09:00:00', 'active'),
(9, 8, 'saving', 80000000, '2020-07-15 11:00:00', 'active'),
(10, 9, 'checking', 25000000, '2020-07-16 10:00:00', 'active'),
(11, 10, 'saving', 75000000, '2020-07-24 11:00:00', 'active'),
(12, 11, 'checking', 25000000, '2020-08-08 10:00:00', 'active'),
(13, 12, 'saving', 55000000, '2020-08-15 11:00:00', 'active'),
(14, 13, 'checking', 25000000, '2020-08-15 14:00:00', 'active'),
(15, 14, 'saving', 45000000, '2020-09-25 08:00:00', 'terminated'),
(16, 15, 'checking', 25000000, '2020-09-26 09:00:00', 'active'),
(17, 15, 'saving', 10000000, '2020-10-19 09:00:00', 'active'),
(18, 17, 'checking', 25000000, '2020-10-21 10:00:00', 'active'),
(19, 18, 'saving', 55000000, '2020-11-11 09:00:00', 'active'),
(20, 19, 'checking', 25000000, '2020-11-19 08:00:00', 'active'),
(21, 20, 'checking', 6000000, '2020-11-29 08:00:00', 'active'),
(22, 3, 'checking', 4000000, '2022-08-18 10:00:00', 'active'),
(23, 6, 'checking', 5000000, '2022-01-10 12:00:00', 'active');




--
-- Data for Name: _dbo_branch; Type: TABLE DATA; Schema: public; Owner: current_user
--

INSERT INTO public._dbo_branch (branch_id, branch_name, branch_location) VALUES
(1, 'KC Jakarta', 'Jl. Gatot Subroto No 13'),
(2, 'KC Bogor', 'Jl. Padjajaran No 43'),
(3, 'KC Depok', 'Jl. Raya Sawangan No 34'),
(4, 'KC Tangerang', 'Jl. Cisauk No 50'),
(5, 'KC Bekasi', 'Jl. Ahmad Yani No 23');



--
-- Data for Name: _dbo_city; Type: TABLE DATA; Schema: public; Owner: current_user
--

INSERT INTO public._dbo_city (city_id, city_name, state_id) VALUES
(1, 'Cilincing', 1),
(2, 'Kelapa Gading', 1),
(3, 'Tanjung Priok', 1),
(4, 'Koja', 1),
(5, 'Pademangan', 1),
(6, 'Penjaringan', 1),
(7, 'Cilandak', 2),
(8, 'Jagakarsa', 2),
(9, 'Mampang Prapatan', 2),
(10, 'Pancoran', 2),
(11, 'Tebet', 2),
(12, 'Setiabudi', 2),
(13, 'Gambir', 3),
(14, 'Sawah Besar', 3),
(15, 'Kemayoran', 3),
(16, 'Menteng', 3),
(17, 'Senen', 3),
(18, 'Tanah Abang', 3),
(19, 'Gambir', 3),
(20, 'Cakung', 4),
(21, 'Ciracas', 4),
(22, 'Duren Sawit', 4),
(23, 'Jatinegara', 4),
(24, 'Pasar Rebo', 4),
(25, 'Pulo Gadung', 4),
(26, 'Cengkareng', 5),
(27, 'Grogol Petamburan', 5),
(28, 'Kebon Jeruk', 5),
(29, 'Palmerah', 5),
(30, 'Kalideres', 5),
(31, 'Bojonggede', 6),
(32, 'Ciawi', 6),
(33, 'Cibinong', 6),
(34, 'Cileungsi', 6),
(35, 'Ciomas', 6),
(36, 'Tajurhalang', 6),
(37, 'Beji', 7),
(38, 'Cilodong', 7),
(39, 'Cinere', 7),
(40, 'Cimanggis', 7),
(41, 'Sawangan', 7),
(42, 'Sukmajaya', 7),
(43, 'Balaraja', 8),
(44, 'Cisauk', 8),
(45, 'Tigaraksa', 8),
(46, 'Legok', 8),
(47, 'Kosambi', 8),
(48, 'Babelan', 9),
(49, 'Cibitung', 9),
(50, 'Tambun Selatan', 9),
(51, 'Cikarang Selatan', 9),
(52, 'Sukatani', 9);



--
-- Data for Name: _dbo_customer; Type: TABLE DATA; Schema: public; Owner: current_user
--

INSERT INTO public._dbo_customer (customer_id, customer_name, address, city_id, age, gender, email) VALUES
(1, 'Shelly Juwita', 'Jl. Boulevard No. 31', 2, 25, 'female', 'shelly@gmail.com'),
(2, 'Bobi Rinaldo', 'Jl. Mangga No. 1', 3, 31, 'male', 'Bobi@gmail.com'),
(3, 'Adam Malik', 'Jl. Kincir Angin No. 50', 5, 23, 'male', 'Adam@gmail.com'),
(4, 'Susi Rahmawati', 'Jl. Kenanga No. 11', 7, 45, 'female', 'Susi@gmail.com'),
(5, 'Dimas Prasetyo', 'Jl. Niagara No. 69', 8, 32, 'male', 'Dimas@gmail.com'),
(6, 'Aji Pangestu', 'Jl. Sempurna No. 2', 9, 40, 'male', 'Aji@gmail.com'),
(7, 'Bunga Malika', 'Jl. Merak No. 10', 33, 27, 'female', 'Bunga@gmail.com'),
(8, 'Ria Addini', 'Jl. Arjuna No. 40', 16, 29, 'female', 'Ria@gmail.com'),
(9, 'Lisa Wulandari', 'Jl. Ampera No. 39', 11, 26, 'female', 'Lisa@gmail.com'),
(10, 'Rio Wijaya', 'Jl. Abdul Muis No. 70', 13, 52, 'male', 'Rio@gmail.com'),
(11, 'Ahmad Riyansah', 'Jl. Kecapi No. 5', 48, 27, 'male', 'Ahmad@gmail.com'),
(12, 'Mario Robert', 'Jl. Kebayoran No. 13', 44, 28, 'male', 'Mario@gmail.com'),
(13, 'Khansa Audya', 'Jl. Kedoya No. 50', 39, 32, 'female', 'Khansa@gmail.com'),
(14, 'Cintya Gabriela', 'Jl. Pintu Air No. 14', 30, 24, 'female', 'Cintya@gmail.com'),
(15, 'Ani Nuraini', 'Jl. Cimpedak No. 50', 49, 45, 'female', 'Ani@gmail.com'),
(16, 'Agung Mulyono', 'Jl. Daan Mogot No. 60', 29, 38, 'male', 'Agung@gmail.com'),
(17, 'Rian Wibowo', 'Jl. Batu No. 49', 31, 41, 'male', 'Rian@gmail.com'),
(18, 'Lutfi Aulia', 'Jl. Elang No. 2', 32, 30, 'male', 'Lutfi@gmail.com'),
(19, 'Malika Cantika', 'Jl. Imam Bonjol No. 30', 43, 38, 'female', 'Malika@gmail.com'),
(20, 'Ratna Sariasih', 'Jl. Jambore No. 41', 52, 53, 'female', 'Ratna@gmail.com');



--
-- Data for Name: _dbo_state; Type: TABLE DATA; Schema: public; Owner: current_user
--

INSERT INTO public._dbo_state (state_id, state_name) VALUES
(1, 'Jakarta Utara'),
(2, 'Jakarta Selatan'),
(3, 'Jakarta Pusat'),
(4, 'Jakarta Timur'),
(5, 'Jakarta Barat'),
(6, 'Bogor'),
(7, 'Depok'),
(8, 'Tangerang'),
(9, 'Bekasi');




--
-- Data for Name: _dbo_transaction_db; Type: TABLE DATA; Schema: public; Owner: current_user
--

INSERT INTO public._dbo_transaction_db (transaction_id, account_id, transaction_date, amount, transaction_type, branch_id) VALUES
(1, 1, '2024-01-17 09:10:00', 100000, 'Deposit', 1),
(2, 2, '2024-01-17 10:10:00', 1000000, 'Deposit', 1),
(3, 3, '2024-01-18 08:30:00', 10000000, 'Transfer', 1),
(4, 3, '2024-01-18 10:45:00', 1000000, 'Withdrawal', 1),
(5, 5, '2024-01-18 11:10:00', 200000, 'Deposit', 1),
(6, 6, '2024-01-18 13:10:00', 50000, 'Withdrawal', 1),
(7, 6, '2024-01-19 14:00:00', 100000, 'Payment', 1),
(8, 7, '2024-01-19 09:10:00', 5000000, 'Deposit', 1),
(9, 8, '2024-01-19 10:40:00', 300000, 'Withdrawal', 2),
(10, 9, '2024-01-20 12:10:00', 2000000, 'Deposit', 1);



--
-- PostgreSQL database dump complete
--

