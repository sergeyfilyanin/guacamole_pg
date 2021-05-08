--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.20
-- Dumped by pg_dump version 9.6.20

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
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


--
-- Name: guacamole_connection_group_type; Type: TYPE; Schema: public; Owner: kong
--

CREATE TYPE public.guacamole_connection_group_type AS ENUM (
    'ORGANIZATIONAL',
    'BALANCING'
);


ALTER TYPE public.guacamole_connection_group_type OWNER TO kong;

--
-- Name: guacamole_entity_type; Type: TYPE; Schema: public; Owner: kong
--

CREATE TYPE public.guacamole_entity_type AS ENUM (
    'USER',
    'USER_GROUP'
);


ALTER TYPE public.guacamole_entity_type OWNER TO kong;

--
-- Name: guacamole_object_permission_type; Type: TYPE; Schema: public; Owner: kong
--

CREATE TYPE public.guacamole_object_permission_type AS ENUM (
    'READ',
    'UPDATE',
    'DELETE',
    'ADMINISTER'
);


ALTER TYPE public.guacamole_object_permission_type OWNER TO kong;

--
-- Name: guacamole_proxy_encryption_method; Type: TYPE; Schema: public; Owner: kong
--

CREATE TYPE public.guacamole_proxy_encryption_method AS ENUM (
    'NONE',
    'SSL'
);


ALTER TYPE public.guacamole_proxy_encryption_method OWNER TO kong;

--
-- Name: guacamole_system_permission_type; Type: TYPE; Schema: public; Owner: kong
--

CREATE TYPE public.guacamole_system_permission_type AS ENUM (
    'CREATE_CONNECTION',
    'CREATE_CONNECTION_GROUP',
    'CREATE_SHARING_PROFILE',
    'CREATE_USER',
    'CREATE_USER_GROUP',
    'ADMINISTER'
);


ALTER TYPE public.guacamole_system_permission_type OWNER TO kong;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: guacamole_connection; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_connection (
    connection_id integer NOT NULL,
    connection_name character varying(128) NOT NULL,
    parent_id integer,
    protocol character varying(32) NOT NULL,
    max_connections integer,
    max_connections_per_user integer,
    connection_weight integer,
    failover_only boolean DEFAULT false NOT NULL,
    proxy_port integer,
    proxy_hostname character varying(512),
    proxy_encryption_method public.guacamole_proxy_encryption_method
);


ALTER TABLE public.guacamole_connection OWNER TO kong;

--
-- Name: guacamole_connection_attribute; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_connection_attribute (
    connection_id integer NOT NULL,
    attribute_name character varying(128) NOT NULL,
    attribute_value character varying(4096) NOT NULL
);


ALTER TABLE public.guacamole_connection_attribute OWNER TO kong;

--
-- Name: guacamole_connection_connection_id_seq; Type: SEQUENCE; Schema: public; Owner: kong
--

CREATE SEQUENCE public.guacamole_connection_connection_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.guacamole_connection_connection_id_seq OWNER TO kong;

--
-- Name: guacamole_connection_connection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kong
--

ALTER SEQUENCE public.guacamole_connection_connection_id_seq OWNED BY public.guacamole_connection.connection_id;


--
-- Name: guacamole_connection_group; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_connection_group (
    connection_group_id integer NOT NULL,
    parent_id integer,
    connection_group_name character varying(128) NOT NULL,
    type public.guacamole_connection_group_type DEFAULT 'ORGANIZATIONAL'::public.guacamole_connection_group_type NOT NULL,
    max_connections integer,
    max_connections_per_user integer,
    enable_session_affinity boolean DEFAULT false NOT NULL
);


ALTER TABLE public.guacamole_connection_group OWNER TO kong;

--
-- Name: guacamole_connection_group_attribute; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_connection_group_attribute (
    connection_group_id integer NOT NULL,
    attribute_name character varying(128) NOT NULL,
    attribute_value character varying(4096) NOT NULL
);


ALTER TABLE public.guacamole_connection_group_attribute OWNER TO kong;

--
-- Name: guacamole_connection_group_connection_group_id_seq; Type: SEQUENCE; Schema: public; Owner: kong
--

CREATE SEQUENCE public.guacamole_connection_group_connection_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.guacamole_connection_group_connection_group_id_seq OWNER TO kong;

--
-- Name: guacamole_connection_group_connection_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kong
--

ALTER SEQUENCE public.guacamole_connection_group_connection_group_id_seq OWNED BY public.guacamole_connection_group.connection_group_id;


--
-- Name: guacamole_connection_group_permission; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_connection_group_permission (
    entity_id integer NOT NULL,
    connection_group_id integer NOT NULL,
    permission public.guacamole_object_permission_type NOT NULL,
    user_id integer
);


ALTER TABLE public.guacamole_connection_group_permission OWNER TO kong;

--
-- Name: guacamole_connection_history; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_connection_history (
    history_id integer NOT NULL,
    user_id integer,
    username character varying(128) NOT NULL,
    remote_host character varying(256) DEFAULT NULL::character varying,
    connection_id integer,
    connection_name character varying(128) NOT NULL,
    sharing_profile_id integer,
    sharing_profile_name character varying(128) DEFAULT NULL::character varying,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone
);


ALTER TABLE public.guacamole_connection_history OWNER TO kong;

--
-- Name: guacamole_connection_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: kong
--

CREATE SEQUENCE public.guacamole_connection_history_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.guacamole_connection_history_history_id_seq OWNER TO kong;

--
-- Name: guacamole_connection_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kong
--

ALTER SEQUENCE public.guacamole_connection_history_history_id_seq OWNED BY public.guacamole_connection_history.history_id;


--
-- Name: guacamole_connection_parameter; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_connection_parameter (
    connection_id integer NOT NULL,
    parameter_name character varying(128) NOT NULL,
    parameter_value character varying(4096) NOT NULL
);


ALTER TABLE public.guacamole_connection_parameter OWNER TO kong;

--
-- Name: guacamole_connection_permission; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_connection_permission (
    entity_id integer NOT NULL,
    connection_id integer NOT NULL,
    permission public.guacamole_object_permission_type NOT NULL,
    user_id integer
);


ALTER TABLE public.guacamole_connection_permission OWNER TO kong;

--
-- Name: guacamole_entity; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_entity (
    entity_id integer NOT NULL,
    name character varying(128) NOT NULL,
    type public.guacamole_entity_type NOT NULL
);


ALTER TABLE public.guacamole_entity OWNER TO kong;

--
-- Name: guacamole_entity_entity_id_seq; Type: SEQUENCE; Schema: public; Owner: kong
--

CREATE SEQUENCE public.guacamole_entity_entity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.guacamole_entity_entity_id_seq OWNER TO kong;

--
-- Name: guacamole_entity_entity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kong
--

ALTER SEQUENCE public.guacamole_entity_entity_id_seq OWNED BY public.guacamole_entity.entity_id;


--
-- Name: guacamole_sharing_profile; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_sharing_profile (
    sharing_profile_id integer NOT NULL,
    sharing_profile_name character varying(128) NOT NULL,
    primary_connection_id integer NOT NULL
);


ALTER TABLE public.guacamole_sharing_profile OWNER TO kong;

--
-- Name: guacamole_sharing_profile_attribute; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_sharing_profile_attribute (
    sharing_profile_id integer NOT NULL,
    attribute_name character varying(128) NOT NULL,
    attribute_value character varying(4096) NOT NULL
);


ALTER TABLE public.guacamole_sharing_profile_attribute OWNER TO kong;

--
-- Name: guacamole_sharing_profile_parameter; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_sharing_profile_parameter (
    sharing_profile_id integer NOT NULL,
    parameter_name character varying(128) NOT NULL,
    parameter_value character varying(4096) NOT NULL
);


ALTER TABLE public.guacamole_sharing_profile_parameter OWNER TO kong;

--
-- Name: guacamole_sharing_profile_permission; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_sharing_profile_permission (
    entity_id integer NOT NULL,
    sharing_profile_id integer NOT NULL,
    permission public.guacamole_object_permission_type NOT NULL,
    user_id integer
);


ALTER TABLE public.guacamole_sharing_profile_permission OWNER TO kong;

--
-- Name: guacamole_sharing_profile_sharing_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: kong
--

CREATE SEQUENCE public.guacamole_sharing_profile_sharing_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.guacamole_sharing_profile_sharing_profile_id_seq OWNER TO kong;

--
-- Name: guacamole_sharing_profile_sharing_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kong
--

ALTER SEQUENCE public.guacamole_sharing_profile_sharing_profile_id_seq OWNED BY public.guacamole_sharing_profile.sharing_profile_id;


--
-- Name: guacamole_system_permission; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_system_permission (
    entity_id integer NOT NULL,
    permission public.guacamole_system_permission_type NOT NULL,
    user_id integer
);


ALTER TABLE public.guacamole_system_permission OWNER TO kong;

--
-- Name: guacamole_user; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_user (
    user_id integer NOT NULL,
    entity_id integer NOT NULL,
    password_hash bytea NOT NULL,
    password_salt bytea,
    password_date timestamp with time zone NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    expired boolean DEFAULT false NOT NULL,
    access_window_start time without time zone,
    access_window_end time without time zone,
    valid_from date,
    valid_until date,
    timezone character varying(64),
    full_name character varying(256),
    email_address character varying(256),
    organization character varying(256),
    organizational_role character varying(256),
    username character varying(256)
);


ALTER TABLE public.guacamole_user OWNER TO kong;

--
-- Name: guacamole_user_attribute; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_user_attribute (
    user_id integer NOT NULL,
    attribute_name character varying(128) NOT NULL,
    attribute_value character varying(4096) NOT NULL
);


ALTER TABLE public.guacamole_user_attribute OWNER TO kong;

--
-- Name: guacamole_user_group; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_user_group (
    user_group_id integer NOT NULL,
    entity_id integer NOT NULL,
    disabled boolean DEFAULT false NOT NULL
);


ALTER TABLE public.guacamole_user_group OWNER TO kong;

--
-- Name: guacamole_user_group_attribute; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_user_group_attribute (
    user_group_id integer NOT NULL,
    attribute_name character varying(128) NOT NULL,
    attribute_value character varying(4096) NOT NULL
);


ALTER TABLE public.guacamole_user_group_attribute OWNER TO kong;

--
-- Name: guacamole_user_group_member; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_user_group_member (
    user_group_id integer NOT NULL,
    member_entity_id integer NOT NULL
);


ALTER TABLE public.guacamole_user_group_member OWNER TO kong;

--
-- Name: guacamole_user_group_permission; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_user_group_permission (
    entity_id integer NOT NULL,
    affected_user_group_id integer NOT NULL,
    permission public.guacamole_object_permission_type NOT NULL
);


ALTER TABLE public.guacamole_user_group_permission OWNER TO kong;

--
-- Name: guacamole_user_group_user_group_id_seq; Type: SEQUENCE; Schema: public; Owner: kong
--

CREATE SEQUENCE public.guacamole_user_group_user_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.guacamole_user_group_user_group_id_seq OWNER TO kong;

--
-- Name: guacamole_user_group_user_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kong
--

ALTER SEQUENCE public.guacamole_user_group_user_group_id_seq OWNED BY public.guacamole_user_group.user_group_id;


--
-- Name: guacamole_user_history; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_user_history (
    history_id integer NOT NULL,
    user_id integer,
    username character varying(128) NOT NULL,
    remote_host character varying(256) DEFAULT NULL::character varying,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone
);


ALTER TABLE public.guacamole_user_history OWNER TO kong;

--
-- Name: guacamole_user_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: kong
--

CREATE SEQUENCE public.guacamole_user_history_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.guacamole_user_history_history_id_seq OWNER TO kong;

--
-- Name: guacamole_user_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kong
--

ALTER SEQUENCE public.guacamole_user_history_history_id_seq OWNED BY public.guacamole_user_history.history_id;


--
-- Name: guacamole_user_password_history; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_user_password_history (
    password_history_id integer NOT NULL,
    user_id integer NOT NULL,
    password_hash bytea NOT NULL,
    password_salt bytea,
    password_date timestamp with time zone NOT NULL
);


ALTER TABLE public.guacamole_user_password_history OWNER TO kong;

--
-- Name: guacamole_user_password_history_password_history_id_seq; Type: SEQUENCE; Schema: public; Owner: kong
--

CREATE SEQUENCE public.guacamole_user_password_history_password_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.guacamole_user_password_history_password_history_id_seq OWNER TO kong;

--
-- Name: guacamole_user_password_history_password_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kong
--

ALTER SEQUENCE public.guacamole_user_password_history_password_history_id_seq OWNED BY public.guacamole_user_password_history.password_history_id;


--
-- Name: guacamole_user_permission; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.guacamole_user_permission (
    entity_id integer NOT NULL,
    affected_user_id integer NOT NULL,
    permission public.guacamole_object_permission_type NOT NULL,
    user_id integer
);


ALTER TABLE public.guacamole_user_permission OWNER TO kong;

--
-- Name: guacamole_user_user_id_seq; Type: SEQUENCE; Schema: public; Owner: kong
--

CREATE SEQUENCE public.guacamole_user_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.guacamole_user_user_id_seq OWNER TO kong;

--
-- Name: guacamole_user_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kong
--

ALTER SEQUENCE public.guacamole_user_user_id_seq OWNED BY public.guacamole_user.user_id;


--
-- Name: guacamole_connection connection_id; Type: DEFAULT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection ALTER COLUMN connection_id SET DEFAULT nextval('public.guacamole_connection_connection_id_seq'::regclass);


--
-- Name: guacamole_connection_group connection_group_id; Type: DEFAULT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_group ALTER COLUMN connection_group_id SET DEFAULT nextval('public.guacamole_connection_group_connection_group_id_seq'::regclass);


--
-- Name: guacamole_connection_history history_id; Type: DEFAULT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_history ALTER COLUMN history_id SET DEFAULT nextval('public.guacamole_connection_history_history_id_seq'::regclass);


--
-- Name: guacamole_entity entity_id; Type: DEFAULT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_entity ALTER COLUMN entity_id SET DEFAULT nextval('public.guacamole_entity_entity_id_seq'::regclass);


--
-- Name: guacamole_sharing_profile sharing_profile_id; Type: DEFAULT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_sharing_profile ALTER COLUMN sharing_profile_id SET DEFAULT nextval('public.guacamole_sharing_profile_sharing_profile_id_seq'::regclass);


--
-- Name: guacamole_user user_id; Type: DEFAULT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user ALTER COLUMN user_id SET DEFAULT nextval('public.guacamole_user_user_id_seq'::regclass);


--
-- Name: guacamole_user_group user_group_id; Type: DEFAULT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_group ALTER COLUMN user_group_id SET DEFAULT nextval('public.guacamole_user_group_user_group_id_seq'::regclass);


--
-- Name: guacamole_user_history history_id; Type: DEFAULT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_history ALTER COLUMN history_id SET DEFAULT nextval('public.guacamole_user_history_history_id_seq'::regclass);


--
-- Name: guacamole_user_password_history password_history_id; Type: DEFAULT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_password_history ALTER COLUMN password_history_id SET DEFAULT nextval('public.guacamole_user_password_history_password_history_id_seq'::regclass);


--
-- Data for Name: guacamole_connection; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_connection (connection_id, connection_name, parent_id, protocol, max_connections, max_connections_per_user, connection_weight, failover_only, proxy_port, proxy_hostname, proxy_encryption_method) FROM stdin;
11	Wave-Bastion	\N	rdp	10	10	\N	f	4882	guacd	NONE
12	SO-Rackspace	\N	rdp	10	10	\N	f	4882	guacd	NONE
13	Castle Bastion	\N	ssh	10	10	\N	f	4882	guacd	NONE
15	BES_Production	\N	rdp	10	10	\N	f	4882	guacd	NONE
14	Win_7	\N	rdp	10	10	\N	f	4882	guacd	NONE
16	Win_10	\N	rdp	10	10	\N	f	4882	guacd	NONE
17	Ubuntu-Office	\N	rdp	2	2	\N	f	4882	guacd	NONE
10	Amazon	\N	rdp	10	10	\N	f	4882	guacd	NONE
18	Gentrack-VPN	\N	rdp	10	10	\N	f	4882	guacd	NONE
\.


--
-- Data for Name: guacamole_connection_attribute; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_connection_attribute (connection_id, attribute_name, attribute_value) FROM stdin;
\.


--
-- Name: guacamole_connection_connection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kong
--

SELECT pg_catalog.setval('public.guacamole_connection_connection_id_seq', 18, true);


--
-- Data for Name: guacamole_connection_group; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_connection_group (connection_group_id, parent_id, connection_group_name, type, max_connections, max_connections_per_user, enable_session_affinity) FROM stdin;
\.


--
-- Data for Name: guacamole_connection_group_attribute; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_connection_group_attribute (connection_group_id, attribute_name, attribute_value) FROM stdin;
\.


--
-- Name: guacamole_connection_group_connection_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kong
--

SELECT pg_catalog.setval('public.guacamole_connection_group_connection_group_id_seq', 1, false);


--
-- Data for Name: guacamole_connection_group_permission; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_connection_group_permission (entity_id, connection_group_id, permission, user_id) FROM stdin;
\.


--
-- Data for Name: guacamole_connection_history; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_connection_history (history_id, user_id, username, remote_host, connection_id, connection_name, sharing_profile_id, sharing_profile_name, start_date, end_date) FROM stdin;
547	1	guacadmin	172.17.0.1	\N	ssh	\N	\N	2020-05-13 22:30:21.622+00	2020-05-13 22:30:22.975+00
591	1	guacadmin	172.17.0.1	\N	ubuntu-desktop	\N	\N	2020-06-04 20:40:34.345+00	2020-06-04 20:44:45.053+00
592	1	guacadmin	172.17.0.1	\N	ubuntu-desktop	\N	\N	2020-06-04 20:44:45.59+00	2020-06-04 20:45:39.321+00
593	1	guacadmin	172.17.0.1	\N	ubuntu-desktop	\N	\N	2020-06-04 20:45:58.792+00	2020-06-04 21:07:12.324+00
594	1	guacadmin	172.17.0.1	\N	ubuntu-desktop	\N	\N	2020-06-05 05:51:42.007+00	2020-06-05 08:39:05.367+00
543	1	guacadmin	172.17.0.1	\N	work	\N	\N	2020-05-13 22:26:50.382+00	2020-05-13 22:26:50.682+00
544	1	guacadmin	172.17.0.1	\N	work	\N	\N	2020-05-13 22:26:58.689+00	2020-05-13 22:26:58.904+00
545	1	guacadmin	172.17.0.1	\N	work	\N	\N	2020-05-13 22:27:47.312+00	2020-05-13 22:27:47.752+00
546	1	guacadmin	172.17.0.1	\N	work	\N	\N	2020-05-13 22:29:41.899+00	2020-05-13 22:29:42.244+00
548	1	guacadmin	172.17.0.1	\N	work	\N	\N	2020-05-13 22:31:19.016+00	2020-05-13 22:31:19.322+00
549	1	guacadmin	172.17.0.1	\N	work	\N	\N	2020-05-13 22:33:18.188+00	2020-05-13 22:33:18.53+00
550	1	guacadmin	172.17.0.1	\N	telnet	\N	\N	2020-05-13 22:39:05.001+00	2020-05-13 22:39:05.314+00
551	1	guacadmin	172.17.0.1	\N	telnet	\N	\N	2020-05-13 22:39:45.726+00	2020-05-13 22:39:45.964+00
552	1	guacadmin	172.17.0.1	\N	telnet	\N	\N	2020-05-13 22:45:54.736+00	2020-05-13 22:45:55.156+00
553	1	guacadmin	172.17.0.1	\N	telnet	\N	\N	2020-05-13 22:47:39.544+00	2020-05-13 22:47:39.828+00
554	1	guacadmin	172.17.0.1	\N	telnet	\N	\N	2020-05-13 22:55:30.027+00	2020-05-13 22:55:30.324+00
555	1	guacadmin	172.17.0.1	\N	telnet	\N	\N	2020-05-13 22:57:03.625+00	2020-05-13 22:58:06.452+00
556	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-13 22:58:29.987+00	2020-05-13 22:59:36.643+00
557	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-13 22:59:56.404+00	2020-05-13 23:00:23.639+00
558	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-13 23:01:18.093+00	2020-05-13 23:03:16.716+00
559	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-13 23:03:17.088+00	2020-05-13 23:03:50.018+00
560	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-13 23:03:50.332+00	2020-05-13 23:03:54.426+00
561	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-13 23:04:45.578+00	2020-05-13 23:05:12.778+00
562	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-13 23:05:37.295+00	2020-05-13 23:05:40.123+00
563	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-13 23:05:40.38+00	2020-05-13 23:05:41.519+00
564	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-13 23:05:41.724+00	2020-05-13 23:05:46.239+00
565	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-13 23:05:46.45+00	2020-05-13 23:05:56.125+00
568	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-13 23:06:36.542+00	2020-05-13 23:07:14.979+00
569	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-13 23:07:40.543+00	2020-05-13 23:15:44.347+00
570	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-14 11:59:40.917+00	2020-05-14 11:59:47.549+00
571	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-14 12:48:50.593+00	2020-05-14 12:49:54.267+00
572	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-14 19:43:37.958+00	2020-05-14 19:45:48.658+00
573	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-16 08:03:00.829+00	2020-05-16 08:11:23.705+00
574	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-16 08:11:24.137+00	2020-05-16 08:11:36.274+00
575	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-16 08:11:36.56+00	2020-05-16 08:17:20.677+00
576	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-16 14:22:09.524+00	2020-05-16 14:23:15.298+00
577	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-18 08:03:37.485+00	2020-05-18 08:04:07.421+00
578	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-18 08:04:07.842+00	2020-05-18 08:12:29.783+00
579	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-18 08:12:30.385+00	2020-05-18 08:12:50.31+00
580	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-18 08:12:56.042+00	2020-05-18 08:14:37.581+00
581	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-19 05:16:08.067+00	2020-05-19 05:17:39.882+00
582	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-19 05:18:31.288+00	2020-05-19 05:22:42.156+00
583	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-21 11:48:45.9+00	2020-05-21 11:50:53.804+00
584	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-24 09:03:50.537+00	2020-05-24 09:06:33.195+00
585	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-25 18:28:13.926+00	2020-05-25 18:29:37.917+00
586	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-25 18:34:10.71+00	2020-05-25 18:35:36.125+00
587	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-25 18:35:44.039+00	2020-05-25 18:37:08.044+00
588	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-25 18:37:10.529+00	2020-05-25 18:37:41.999+00
589	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-05-27 06:35:51.504+00	2020-05-27 06:54:53.263+00
595	1	guacadmin	172.17.0.1	\N	vnc	\N	\N	2020-06-05 05:53:11.466+00	2020-06-05 08:39:05.368+00
602	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-27 12:05:03.093+00	2021-01-27 12:32:54.308+00
603	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-27 12:32:55.01+00	2021-01-27 12:33:42.624+00
604	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-27 12:33:43.759+00	2021-01-27 12:49:08.646+00
605	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-27 12:49:13.504+00	2021-01-27 13:04:09.444+00
606	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-27 13:08:57.938+00	2021-01-27 14:13:40.658+00
607	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-27 16:30:57.008+00	2021-01-27 16:31:00.422+00
608	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-27 16:31:34.946+00	2021-01-27 16:31:35.574+00
609	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-27 16:31:37.916+00	2021-01-27 16:31:38.475+00
610	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-27 16:31:39.955+00	2021-01-27 16:31:40.53+00
611	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-27 16:31:55.656+00	2021-01-27 16:31:56.24+00
612	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-27 16:32:11.39+00	2021-01-27 16:32:12.018+00
613	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-27 16:32:27.389+00	2021-01-27 16:32:27.947+00
614	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-27 16:36:28.334+00	2021-01-27 16:40:06.018+00
615	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-27 16:40:30.269+00	2021-01-27 16:41:15.432+00
616	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-27 17:20:19.015+00	2021-01-27 17:20:22.574+00
617	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-28 07:42:34.488+00	2021-01-28 07:43:44.714+00
618	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-28 07:54:40.579+00	2021-01-28 08:21:15.426+00
619	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-28 08:21:40.361+00	2021-01-28 09:01:56.597+00
620	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-28 09:01:46.83+00	2021-01-28 09:02:20.114+00
621	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-01-28 09:30:13.951+00	2021-01-28 09:30:54.738+00
622	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-02-02 09:06:03.703+00	2021-02-02 09:06:16.683+00
623	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-02 09:08:47.063+00	2021-02-02 09:35:36.277+00
624	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-02 11:33:50.585+00	2021-02-02 12:47:22.738+00
625	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-02 12:48:33.335+00	2021-02-02 13:07:53.964+00
626	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-02 13:13:58.24+00	2021-02-02 13:27:23.59+00
627	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-02 13:27:20.005+00	2021-02-02 13:40:15.416+00
628	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-02-02 13:56:08.162+00	2021-02-02 13:56:48.147+00
629	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-02 13:40:12.79+00	2021-02-02 14:02:42.709+00
630	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-02 14:06:19.392+00	2021-02-02 14:18:37.585+00
631	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-02 14:18:34.856+00	2021-02-02 15:08:01.659+00
632	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-02 15:07:58.927+00	2021-02-02 15:29:06.022+00
633	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-03 06:46:18.963+00	2021-02-03 08:01:26.483+00
634	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-03 10:40:54.82+00	2021-02-03 11:34:41.565+00
635	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-03 11:49:36.439+00	2021-02-03 12:07:08.324+00
636	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-03 14:06:13.198+00	2021-02-03 14:11:19.801+00
637	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-04 10:32:49.231+00	2021-02-04 11:36:21.753+00
638	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-07 09:11:00.927+00	2021-02-07 09:33:37.599+00
639	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-02-08 10:01:36.88+00	2021-02-08 10:02:21.862+00
640	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-02-08 10:24:53.928+00	2021-02-08 10:25:09.55+00
641	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-08 10:01:59.07+00	2021-02-08 10:43:12.396+00
642	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-02-08 10:25:37.439+00	2021-02-08 10:49:37.515+00
643	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-02-08 23:56:05.523+00	2021-02-08 23:56:14.931+00
644	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-11 09:28:36.385+00	2021-02-11 09:28:51.147+00
645	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-11 09:28:51.542+00	2021-02-11 10:15:18.564+00
646	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-12 08:41:03.946+00	2021-02-12 09:43:46.118+00
647	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-13 07:57:57.562+00	2021-02-13 08:08:17.823+00
648	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-02-13 08:08:20.939+00	2021-02-13 09:20:26.78+00
649	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-02-14 06:48:38.955+00	2021-02-14 07:09:29.317+00
650	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-02-14 07:10:09.579+00	2021-02-14 07:12:31.746+00
651	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-14 07:09:44.062+00	2021-02-14 07:12:31.757+00
652	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-02-14 07:52:46.035+00	2021-02-14 07:56:20.577+00
653	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-02-15 06:53:17.602+00	2021-02-15 08:17:11.282+00
654	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-19 07:22:53.734+00	2021-02-19 07:23:15.92+00
655	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-19 07:23:16.165+00	2021-02-19 07:24:55.196+00
656	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-02-19 07:24:26.522+00	2021-02-19 07:24:55.197+00
657	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-02-19 11:39:32.535+00	2021-02-19 11:41:45.663+00
658	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-02-22 12:03:46.721+00	2021-02-22 12:11:00.122+00
659	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-02-22 12:12:52.791+00	2021-02-22 12:22:23.804+00
660	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-02-22 12:14:22.78+00	2021-02-22 12:22:23.899+00
661	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-03-01 12:09:41.595+00	2021-03-01 12:12:37.492+00
662	1	guacadmin	172.17.0.1	13	Castle Bastion	\N	\N	2021-03-01 13:25:12.082+00	2021-03-01 13:27:21.323+00
663	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:06:01.883+00	2021-03-11 14:06:20.188+00
664	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:06:22.487+00	2021-03-11 14:06:37.978+00
665	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:06:53.074+00	2021-03-11 14:07:08.594+00
666	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:07:23.703+00	2021-03-11 14:07:39.231+00
667	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:07:54.365+00	2021-03-11 14:08:09.903+00
668	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:08:25.02+00	2021-03-11 14:08:40.56+00
669	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:08:55.669+00	2021-03-11 14:09:11.234+00
670	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:09:26.345+00	2021-03-11 14:09:41.898+00
671	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:09:57.017+00	2021-03-11 14:10:12.569+00
672	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:10:27.682+00	2021-03-11 14:10:43.39+00
673	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:10:58.501+00	2021-03-11 14:11:14.047+00
674	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:11:29.142+00	2021-03-11 14:11:44.668+00
675	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:11:54.147+00	2021-03-11 14:12:09.702+00
676	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:12:24.829+00	2021-03-11 14:12:40.347+00
677	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:12:43.851+00	2021-03-11 14:12:59.44+00
678	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:13:01.87+00	2021-03-11 14:13:17.374+00
679	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:13:32.466+00	2021-03-11 14:13:47.983+00
680	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:14:03.07+00	2021-03-11 14:14:18.608+00
681	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:14:20.91+00	2021-03-11 14:14:36.467+00
682	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:16:50.116+00	2021-03-11 14:17:05.621+00
683	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:20:05.71+00	2021-03-11 14:20:21.217+00
684	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:22:55.7+00	2021-03-11 14:23:11.202+00
685	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:23:26.395+00	2021-03-11 14:23:41.939+00
686	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:23:57.356+00	2021-03-11 14:24:12.849+00
687	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:24:28.367+00	2021-03-11 14:24:43.874+00
688	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:25:21.881+00	2021-03-11 14:26:37.837+00
689	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:26:27.723+00	2021-03-11 14:31:18.654+00
690	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:31:20.2+00	2021-03-11 14:31:35.766+00
691	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:33:13.978+00	2021-03-11 14:33:20.518+00
692	1	guacadmin	172.17.0.1	14	Win_10	\N	\N	2021-03-11 14:33:35.623+00	2021-03-11 14:33:42.189+00
693	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-11 14:44:37.791+00	2021-03-11 14:49:31.847+00
695	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-11 14:50:30.415+00	2021-03-11 15:23:56.894+00
696	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-11 15:55:28.525+00	2021-03-11 15:55:46.999+00
697	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-03-11 15:55:49.488+00	2021-03-11 15:56:05.043+00
698	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 15:58:55.779+00	2021-03-11 15:59:01.349+00
699	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 15:59:02.665+00	2021-03-11 15:59:08.346+00
700	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 15:59:10.311+00	2021-03-11 15:59:27.53+00
701	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 15:59:29.431+00	2021-03-11 15:59:33.062+00
702	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 15:59:34.458+00	2021-03-11 15:59:37.548+00
703	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 15:59:39.49+00	2021-03-11 15:59:42.537+00
704	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:00:09.291+00	2021-03-11 16:00:24.845+00
705	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:00:40.044+00	2021-03-11 16:00:55.643+00
706	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:01:10.767+00	2021-03-11 16:01:17.328+00
707	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:01:32.432+00	2021-03-11 16:01:38.994+00
708	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:01:48.611+00	2021-03-11 16:01:55.138+00
709	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:01:57.08+00	2021-03-11 16:02:12.304+00
710	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:02:16.339+00	2021-03-11 16:02:31.575+00
711	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:02:34.647+00	2021-03-11 16:02:55.675+00
712	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:03:02.248+00	2021-03-11 16:03:45.888+00
713	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:03:47.872+00	2021-03-11 16:03:53.184+00
714	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:03:54.823+00	2021-03-11 16:03:59.129+00
715	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:04:00.569+00	2021-03-11 16:04:04.181+00
716	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:04:09.491+00	2021-03-11 16:04:12.516+00
717	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:04:17.821+00	2021-03-11 16:04:20.953+00
718	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:04:32.671+00	2021-03-11 16:04:37.784+00
719	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:04:41.233+00	2021-03-11 16:04:44.677+00
720	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:04:59.883+00	2021-03-11 16:05:03.649+00
721	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:05:17.539+00	2021-03-11 16:05:21.827+00
722	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:05:26.97+00	2021-03-11 16:05:32.85+00
723	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:05:48.028+00	2021-03-11 16:05:52.235+00
724	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:05:53.619+00	2021-03-11 16:06:00.036+00
725	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:06:09.014+00	2021-03-11 16:06:12.294+00
726	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:06:20.392+00	2021-03-11 16:06:27.975+00
727	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-11 16:06:32.659+00	2021-03-11 16:22:11.321+00
728	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-03-11 15:55:52.201+00	2021-03-11 16:22:11.495+00
729	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-11 16:23:17.028+00	2021-03-11 16:23:21.333+00
730	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-11 16:23:15.988+00	2021-03-11 16:23:31.088+00
731	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:28:32.88+00	2021-03-11 16:28:37.581+00
732	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:28:39.092+00	2021-03-11 16:28:42.365+00
733	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:28:43.834+00	2021-03-11 16:28:47.279+00
734	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:28:48.83+00	2021-03-11 16:28:51.797+00
735	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:28:54.05+00	2021-03-11 16:28:57.117+00
736	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:29:12.244+00	2021-03-11 16:29:15.163+00
737	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:29:16.373+00	2021-03-11 16:29:19.822+00
738	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:29:23.845+00	2021-03-11 16:29:27.14+00
739	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:29:29.24+00	2021-03-11 16:29:35.059+00
740	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:29:52.041+00	2021-03-11 16:29:55.32+00
741	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:30:11.033+00	2021-03-11 16:30:14.213+00
742	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:30:30.037+00	2021-03-11 16:30:33.06+00
743	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:30:49.037+00	2021-03-11 16:30:52.893+00
744	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:31:10.035+00	2021-03-11 16:31:14.732+00
753	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 17:58:27.974+00	2021-03-11 17:58:43.478+00
755	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 17:59:00.32+00	2021-03-11 17:59:10.234+00
764	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:13:05.006+00	2021-03-11 21:13:20.536+00
768	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:15:07.496+00	2021-03-11 21:15:22.981+00
779	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:59:44.314+00	2021-03-11 21:59:59.849+00
786	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-12 06:15:54.896+00	2021-03-12 06:16:01.453+00
790	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-12 06:24:00.254+00	2021-03-12 06:27:26.506+00
745	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:31:30.039+00	2021-03-11 16:31:34.888+00
749	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 17:22:21.026+00	2021-03-11 17:47:30.118+00
754	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 17:56:26.179+00	2021-03-11 17:59:10.229+00
760	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-11 20:32:17.642+00	2021-03-11 21:11:35.848+00
762	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:12:03.782+00	2021-03-11 21:12:19.334+00
766	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:14:06.272+00	2021-03-11 21:14:21.825+00
770	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:16:08.727+00	2021-03-11 21:16:24.263+00
772	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:17:29.27+00	2021-03-11 21:18:18.998+00
774	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:18:35.681+00	2021-03-11 21:18:45.665+00
777	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:42:16.24+00	2021-03-11 21:54:41.221+00
780	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 22:00:14.94+00	2021-03-11 22:00:21.461+00
784	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-12 06:14:19.986+00	2021-03-12 06:15:29.844+00
788	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-12 06:16:38.156+00	2021-03-12 06:16:44.686+00
746	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 16:31:50.036+00	2021-03-11 16:31:53.501+00
752	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 17:58:10.951+00	2021-03-11 17:58:26.493+00
756	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 17:59:10.749+00	2021-03-11 17:59:20.926+00
757	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 17:59:23.761+00	2021-03-11 18:15:48.7+00
759	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-03-11 20:32:08.599+00	2021-03-11 20:32:25.955+00
763	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:12:34.44+00	2021-03-11 21:12:49.91+00
767	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:14:36.912+00	2021-03-11 21:14:52.399+00
771	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:16:39.352+00	2021-03-11 21:16:54.907+00
773	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:18:19.682+00	2021-03-11 21:18:29.662+00
778	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:56:22.757+00	2021-03-11 21:56:38.28+00
782	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 22:00:58.195+00	2021-03-11 22:07:23.199+00
785	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-12 06:15:44.963+00	2021-03-12 06:15:51.592+00
789	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-12 06:16:59.78+00	2021-03-12 06:19:09.763+00
747	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-11 16:23:21.641+00	2021-03-11 16:55:24.496+00
748	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 17:21:19.959+00	2021-03-11 17:22:14.94+00
750	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 17:47:21.407+00	2021-03-11 17:53:36.385+00
751	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 17:57:40.293+00	2021-03-11 17:57:55.833+00
758	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-11 18:08:26.147+00	2021-03-11 19:18:46.251+00
761	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:11:33.126+00	2021-03-11 21:11:48.655+00
765	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:13:35.631+00	2021-03-11 21:13:51.165+00
769	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:15:38.082+00	2021-03-11 21:15:53.617+00
775	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 21:18:51.37+00	2021-03-11 21:19:01.344+00
776	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-11 21:30:37.901+00	2021-03-11 21:32:10.236+00
781	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-11 22:00:36.55+00	2021-03-11 22:00:43.108+00
783	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-12 06:14:07.866+00	2021-03-12 06:14:17.844+00
787	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-12 06:16:16.527+00	2021-03-12 06:16:23.074+00
791	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-12 06:33:56.933+00	2021-03-12 06:48:06.178+00
792	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-12 06:48:07.04+00	2021-03-12 07:55:38.433+00
793	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-12 09:25:09.653+00	2021-03-12 09:25:22.88+00
794	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-12 09:25:25.675+00	2021-03-12 09:25:35.756+00
795	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-12 09:29:42.686+00	2021-03-12 09:30:42.673+00
796	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:02:55.619+00	2021-03-12 10:03:11.16+00
797	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:03:19.717+00	2021-03-12 10:03:38.258+00
798	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:03:53.348+00	2021-03-12 10:04:06.769+00
799	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:08:02.706+00	2021-03-12 10:08:12.704+00
800	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:08:55.682+00	2021-03-12 10:09:55.675+00
801	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:12:35.104+00	2021-03-12 10:12:48.728+00
802	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:13:53.732+00	2021-03-12 10:14:50.405+00
803	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:14:55.347+00	2021-03-12 10:14:59.577+00
804	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:54:12.778+00	2021-03-12 10:54:20.705+00
805	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:54:21.956+00	2021-03-12 10:54:28.269+00
806	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:54:43.379+00	2021-03-12 10:54:49.682+00
807	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:55:04.784+00	2021-03-12 10:55:15.287+00
808	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:55:30.429+00	2021-03-12 10:55:40.387+00
809	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:55:55.509+00	2021-03-12 10:55:59.735+00
810	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:56:14.883+00	2021-03-12 10:56:18.652+00
811	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:56:33.749+00	2021-03-12 10:56:36.964+00
812	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:56:52.086+00	2021-03-12 10:57:02.502+00
813	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 10:57:17.632+00	2021-03-12 10:57:57.976+00
814	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:31:28.413+00	2021-03-12 11:31:37.807+00
815	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:31:53.808+00	2021-03-12 11:32:00.356+00
816	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:32:15.79+00	2021-03-12 11:32:22.354+00
817	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:32:37.792+00	2021-03-12 11:32:44.315+00
818	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:32:59.792+00	2021-03-12 11:33:06.349+00
819	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:33:21.784+00	2021-03-12 11:33:28.311+00
820	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:33:43.793+00	2021-03-12 11:34:57.476+00
821	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:35:01.32+00	2021-03-12 11:35:05.063+00
822	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:35:09.958+00	2021-03-12 11:35:12.968+00
823	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:36:21.208+00	2021-03-12 11:36:24.32+00
824	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:36:39.781+00	2021-03-12 11:36:42.841+00
825	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:36:58.779+00	2021-03-12 11:37:01.854+00
826	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:37:17.781+00	2021-03-12 11:37:20.796+00
827	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:37:36.781+00	2021-03-12 11:37:39.582+00
828	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:37:54.792+00	2021-03-12 11:37:58.228+00
829	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:38:13.78+00	2021-03-12 11:38:16.77+00
830	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:38:32.781+00	2021-03-12 11:38:35.873+00
831	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:38:51.794+00	2021-03-12 11:38:55.379+00
832	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:39:10.789+00	2021-03-12 11:39:14.008+00
833	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:39:18.665+00	2021-03-12 11:39:22.504+00
834	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:40:56.383+00	2021-03-12 11:40:59.587+00
835	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:41:46.94+00	2021-03-12 11:41:54.146+00
836	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:42:09.273+00	2021-03-12 11:42:12.591+00
837	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:42:16.272+00	2021-03-12 11:42:20.101+00
838	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:42:35.201+00	2021-03-12 11:42:37.86+00
839	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:42:53.011+00	2021-03-12 11:42:56.855+00
840	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-12 11:43:11.991+00	2021-03-12 11:43:29.239+00
841	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 10:36:45.531+00	2021-03-16 10:37:14.025+00
842	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 10:37:24.403+00	2021-03-16 10:38:04.496+00
843	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 10:38:06.639+00	2021-03-16 10:53:41.658+00
844	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 10:53:45.997+00	2021-03-16 10:53:52.58+00
845	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 10:54:01.848+00	2021-03-16 11:06:16.924+00
846	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 11:06:20.798+00	2021-03-16 11:08:37.162+00
847	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 11:56:40.466+00	2021-03-16 12:12:09.893+00
848	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:12:25.065+00	2021-03-16 12:12:30.368+00
849	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:12:46.122+00	2021-03-16 12:12:51.976+00
850	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:13:07.113+00	2021-03-16 12:13:11.149+00
851	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:13:27.116+00	2021-03-16 12:13:31.044+00
852	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:13:47.112+00	2021-03-16 12:13:50.593+00
853	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:14:06.161+00	2021-03-16 12:14:09.81+00
854	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:14:25.119+00	2021-03-16 12:14:28.356+00
855	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:14:44.121+00	2021-03-16 12:14:47.445+00
856	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:15:03.113+00	2021-03-16 12:15:06.826+00
857	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:15:22.117+00	2021-03-16 12:15:25.677+00
858	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:15:41.112+00	2021-03-16 12:15:45.794+00
859	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:16:01.116+00	2021-03-16 12:16:05.231+00
860	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:16:21.1+00	2021-03-16 12:16:23.799+00
861	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:16:43.116+00	2021-03-16 12:16:46.574+00
862	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:17:02.112+00	2021-03-16 12:17:05.508+00
863	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:17:21.104+00	2021-03-16 12:17:23.619+00
864	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:17:39.123+00	2021-03-16 12:17:43.092+00
865	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:17:59.125+00	2021-03-16 12:18:01.746+00
866	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:18:17.12+00	2021-03-16 12:18:21.381+00
867	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:18:37.112+00	2021-03-16 12:18:41.557+00
868	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:20:47.747+00	2021-03-16 12:20:51.081+00
869	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:33:22.73+00	2021-03-16 12:33:26.358+00
870	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:33:32.811+00	2021-03-16 12:33:35.595+00
871	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:36:48.178+00	2021-03-16 12:36:51.139+00
872	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:36:52.984+00	2021-03-16 12:36:55.757+00
873	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:36:59.84+00	2021-03-16 12:37:03.805+00
874	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:37:18.953+00	2021-03-16 12:37:22.485+00
875	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:37:37.595+00	2021-03-16 12:37:53.161+00
876	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:38:08.257+00	2021-03-16 12:38:23.81+00
877	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:38:38.901+00	2021-03-16 12:39:45.165+00
878	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:39:49.455+00	2021-03-16 12:39:57.712+00
879	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:40:02.634+00	2021-03-16 12:41:23.372+00
880	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:41:25.226+00	2021-03-16 12:41:29.057+00
881	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:41:31.698+00	2021-03-16 12:41:35.223+00
882	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:41:50.352+00	2021-03-16 12:41:53.6+00
883	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:42:09.096+00	2021-03-16 12:42:11.999+00
884	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:42:29.094+00	2021-03-16 12:42:32.248+00
885	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:42:48.099+00	2021-03-16 12:42:51.636+00
886	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:43:07.095+00	2021-03-16 12:43:11.3+00
887	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:43:27.098+00	2021-03-16 12:43:30.762+00
888	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:43:46.094+00	2021-03-16 12:43:50.335+00
889	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:44:06.116+00	2021-03-16 12:44:08.753+00
890	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:44:24.097+00	2021-03-16 12:44:28.155+00
891	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:44:44.103+00	2021-03-16 12:44:47.405+00
892	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:45:03.113+00	2021-03-16 12:45:05.79+00
893	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:45:21.099+00	2021-03-16 12:45:25.286+00
894	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:45:41.108+00	2021-03-16 12:45:44.924+00
895	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:46:00.095+00	2021-03-16 12:46:04.077+00
896	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:46:20.098+00	2021-03-16 12:46:22.891+00
897	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:46:38.101+00	2021-03-16 12:46:41.183+00
898	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:46:57.097+00	2021-03-16 12:47:00.299+00
899	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 12:57:28.118+00	2021-03-16 12:57:31.002+00
900	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-16 13:08:28.083+00	2021-03-16 13:08:31.016+00
901	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-17 09:55:46.218+00	2021-03-17 10:29:46.871+00
902	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-17 10:30:07.719+00	2021-03-17 10:38:20.461+00
903	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-17 10:38:34.297+00	2021-03-17 10:39:09.073+00
904	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-17 11:04:14.769+00	2021-03-17 13:10:34.318+00
905	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-18 09:45:31.268+00	2021-03-18 11:46:23.114+00
906	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-23 16:45:32.473+00	2021-03-23 17:34:03.171+00
907	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-23 17:39:35.462+00	2021-03-23 17:40:21.955+00
908	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-24 06:10:53.466+00	2021-03-24 06:19:47.963+00
909	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-24 10:57:50.773+00	2021-03-24 10:58:07.663+00
910	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-03-25 08:02:29.766+00	2021-03-25 08:05:21.432+00
911	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-03-25 12:42:08.725+00	2021-03-25 12:42:12.639+00
912	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-25 12:42:15.834+00	2021-03-25 12:42:22.388+00
913	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-25 12:49:30.552+00	2021-03-25 12:49:38.829+00
914	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-25 12:49:40.643+00	2021-03-25 12:49:44.867+00
915	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-25 12:49:56.044+00	2021-03-25 12:50:02.564+00
916	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-25 12:50:38.635+00	2021-03-25 12:50:40.139+00
917	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-25 12:52:15.6+00	2021-03-25 12:52:16.332+00
918	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-25 12:55:01.255+00	2021-03-25 12:55:10.08+00
919	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-25 12:57:22.682+00	2021-03-25 12:57:23.592+00
920	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-25 12:57:24.569+00	2021-03-25 12:57:25.321+00
921	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-25 12:58:54.491+00	2021-03-25 13:15:44.938+00
922	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-25 13:20:32.438+00	2021-03-25 13:33:01.639+00
923	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-25 13:34:05.679+00	2021-03-25 13:34:08.898+00
924	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-25 13:34:15.33+00	2021-03-25 13:34:16.937+00
925	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-25 13:35:16.652+00	2021-03-25 13:35:18.501+00
926	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-03-25 16:40:58.108+00	2021-03-25 17:15:31.594+00
927	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-25 15:48:50.19+00	2021-03-25 17:25:06.204+00
928	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-25 17:25:06.911+00	2021-03-25 17:44:03.972+00
929	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-26 05:19:37.98+00	2021-03-26 05:19:47.936+00
930	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-26 05:19:50.36+00	2021-03-26 05:20:05.908+00
931	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-26 05:20:07.65+00	2021-03-26 05:20:23.197+00
932	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-26 05:20:27.486+00	2021-03-26 05:20:34.042+00
933	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-26 05:20:49.154+00	2021-03-26 05:20:55.722+00
934	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-26 05:21:10.83+00	2021-03-26 05:21:17.406+00
935	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-26 05:21:32.515+00	2021-03-26 05:21:39.175+00
936	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-26 05:21:44.682+00	2021-03-26 05:21:51.223+00
937	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-26 05:22:06.341+00	2021-03-26 05:26:08.61+00
938	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-26 08:50:57.44+00	2021-03-26 08:51:07.407+00
939	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-26 08:51:12.638+00	2021-03-26 08:52:06.271+00
944	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-04-02 07:56:59.466+00	2021-04-02 07:57:15.027+00
948	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-04-02 08:14:17.748+00	2021-04-02 08:14:22.049+00
940	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-26 08:54:54.453+00	2021-03-26 08:55:10+00
941	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-26 08:55:50.801+00	2021-03-26 08:55:57.343+00
942	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-26 08:56:12.448+00	2021-03-26 08:56:19.007+00
943	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-03-26 08:56:34.118+00	2021-03-26 09:10:10.638+00
947	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-04-02 07:46:58.239+00	2021-04-02 08:14:22.047+00
945	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-04-02 07:58:42.639+00	2021-04-02 07:58:52.622+00
946	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-04-02 07:59:17.72+00	2021-04-02 08:14:22.044+00
949	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-02 07:44:20.238+00	2021-04-02 08:14:22.047+00
950	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-04-02 08:20:26.7+00	2021-04-02 08:21:17.501+00
951	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-04-02 08:21:24.712+00	2021-04-02 08:21:35.7+00
964	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-04-07 06:00:05.099+00	2021-04-07 06:00:09.682+00
965	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-04-07 06:00:17.652+00	2021-04-07 06:00:19.889+00
966	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-07 06:00:27.774+00	2021-04-07 06:00:29.779+00
967	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-04-07 06:02:51.337+00	2021-04-07 06:03:16.573+00
968	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-07 06:04:42.351+00	2021-04-07 06:04:50.438+00
969	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-04-07 06:03:23.617+00	2021-04-07 06:04:50.526+00
970	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-07 06:05:01.154+00	2021-04-07 06:05:03.381+00
971	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-07 06:05:05.75+00	2021-04-07 06:05:07.9+00
972	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-07 06:05:18.765+00	2021-04-07 06:05:21.058+00
973	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-04-07 06:05:30.279+00	2021-04-07 06:05:34.644+00
974	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-07 06:05:42.958+00	2021-04-07 06:06:01.16+00
975	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-07 06:06:16.863+00	2021-04-07 06:06:19.067+00
976	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-07 06:06:23.266+00	2021-04-07 06:06:25.432+00
977	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-07 06:06:44.579+00	2021-04-07 06:06:46.784+00
978	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-07 06:07:15.336+00	2021-04-07 06:07:17.612+00
979	1	guacadmin	172.17.0.1	16	Win_10	\N	\N	2021-04-07 06:07:32.943+00	2021-04-07 06:07:57.848+00
986	1	guacadmin	172.17.0.1	14	Win_7	\N	\N	2021-04-07 07:27:15.837+00	2021-04-07 07:27:22.39+00
987	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-07 06:08:03.783+00	2021-04-07 08:12:22.272+00
988	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-07 07:27:20.856+00	2021-04-07 08:12:22.29+00
989	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-07 08:57:15.172+00	2021-04-07 10:17:28.351+00
990	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-08 09:05:48.408+00	2021-04-08 10:06:50.797+00
991	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-08 10:09:59.832+00	2021-04-08 11:20:14.908+00
992	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-04-11 07:02:22.75+00	2021-04-11 07:05:49.745+00
993	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-11 07:00:58.96+00	2021-04-11 07:05:49.747+00
994	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-04-11 07:07:15.313+00	2021-04-11 07:13:42.195+00
995	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-11 07:13:44.407+00	2021-04-11 07:37:15.472+00
996	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-04-11 07:56:25.257+00	2021-04-11 08:15:43.523+00
997	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-11 07:56:09.822+00	2021-04-11 08:15:43.525+00
998	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-04-15 06:23:08.318+00	2021-04-15 06:23:23.86+00
999	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-04-15 06:23:28.731+00	2021-04-15 06:23:44.303+00
1000	1	guacadmin	172.17.0.1	11	Wave-Bastion	\N	\N	2021-04-15 06:24:33.894+00	2021-04-15 06:24:49.453+00
1001	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-04-15 06:37:43.519+00	2021-04-15 06:38:53.933+00
1002	9	gil	172.17.0.1	15	BES_Production	\N	\N	2021-04-15 06:43:09.952+00	2021-04-15 07:00:46.962+00
1003	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-15 06:54:10.779+00	2021-04-15 07:05:37.497+00
1004	1	guacadmin	172.17.0.1	10	chrome-rdp	\N	\N	2021-04-15 10:03:03.683+00	2021-04-15 10:05:14.339+00
1005	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-15 12:32:08.164+00	2021-04-15 12:32:28.912+00
1006	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-15 12:32:35.905+00	2021-04-15 12:36:15.59+00
1007	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-15 12:37:36.909+00	2021-04-15 12:38:04.803+00
1008	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-15 12:41:19.226+00	2021-04-15 12:42:18.938+00
1009	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-15 12:39:51.723+00	2021-04-15 12:43:50.136+00
1010	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-15 12:42:36.462+00	2021-04-15 12:50:34.559+00
1011	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-16 05:58:10.149+00	2021-04-16 05:59:18.664+00
1012	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-04-16 05:59:07.634+00	2021-04-16 06:00:09.133+00
1013	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-16 05:59:38.983+00	2021-04-16 06:00:09.139+00
1014	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-16 07:51:18.606+00	2021-04-16 08:47:10.041+00
1015	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-16 08:45:29.872+00	2021-04-16 09:16:50.452+00
1016	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-04-16 07:51:13.567+00	2021-04-16 09:16:50.548+00
1017	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-16 07:49:32.051+00	2021-04-16 09:16:50.589+00
1018	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-16 08:47:06.277+00	2021-04-16 09:16:50.598+00
1019	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-04-16 07:49:57.956+00	2021-04-16 09:16:50.657+00
1020	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-18 15:50:03.161+00	2021-04-18 15:52:53.203+00
1021	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-18 16:27:16.022+00	2021-04-18 16:41:17.13+00
1022	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-18 16:42:08.363+00	2021-04-18 17:00:24.93+00
1023	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-18 18:15:00.67+00	2021-04-18 18:30:19.54+00
1024	9	gil	172.17.0.1	10	Amazon	\N	\N	2021-04-19 09:43:43.48+00	2021-04-19 09:47:02.097+00
1026	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-04-19 10:50:13.122+00	2021-04-19 10:50:43.357+00
1030	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-19 10:48:12.778+00	2021-04-19 11:57:02.657+00
1034	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-20 08:08:52.659+00	2021-04-20 08:24:47.475+00
1038	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-20 09:28:42.798+00	2021-04-20 09:36:08.306+00
1040	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-20 09:36:05.243+00	2021-04-20 10:03:39.765+00
1044	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-21 06:58:08.161+00	2021-04-21 08:16:15.056+00
1046	1	guacadmin	172.17.0.1	18	Gentrack-VPN	\N	\N	2021-04-21 12:10:19.29+00	2021-04-21 12:10:29.266+00
1049	1	guacadmin	172.17.0.1	18	Gentrack-VPN	\N	\N	2021-04-21 12:17:27.724+00	2021-04-21 12:50:17.712+00
1052	9	gil	172.17.0.1	10	Amazon	\N	\N	2021-04-26 07:56:36.238+00	2021-04-26 08:24:45.899+00
1054	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-26 08:28:38.067+00	2021-04-26 08:28:55.424+00
1056	1	guacadmin	172.17.0.1	18	Gentrack-VPN	\N	\N	2021-04-26 08:27:56.672+00	2021-04-26 08:29:26.284+00
1025	9	gil	172.17.0.1	13	Castle Bastion	\N	\N	2021-04-19 10:04:41.723+00	2021-04-19 10:05:19.24+00
1028	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-04-19 10:50:55.789+00	2021-04-19 11:20:21.59+00
1031	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-20 07:20:21.361+00	2021-04-20 07:21:01.35+00
1032	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-20 07:47:53.97+00	2021-04-20 07:48:23.564+00
1035	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-20 08:24:29.004+00	2021-04-20 08:35:33.301+00
1039	1	guacadmin	172.17.0.1	13	Castle Bastion	\N	\N	2021-04-20 09:42:42.596+00	2021-04-20 09:44:50.102+00
1050	1	guacadmin	172.17.0.1	18	Gentrack-VPN	\N	\N	2021-04-21 13:00:36.608+00	2021-04-21 13:36:03.13+00
1051	9	gil	172.17.0.1	13	Castle Bastion	\N	\N	2021-04-26 07:56:00.309+00	2021-04-26 07:58:07.862+00
1027	9	gil	172.17.0.1	12	SO-Rackspace	\N	\N	2021-04-19 10:05:35.697+00	2021-04-19 10:50:43.387+00
1029	9	gil	172.17.0.1	10	Amazon	\N	\N	2021-04-19 09:51:54.108+00	2021-04-19 11:20:38.256+00
1033	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-04-20 07:48:32.427+00	2021-04-20 07:48:59.794+00
1037	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-20 08:46:15.394+00	2021-04-20 09:28:45.952+00
1041	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-04-20 07:48:55.278+00	2021-04-20 10:03:39.801+00
1045	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-21 12:08:58.194+00	2021-04-21 12:10:22.579+00
1047	1	guacadmin	172.17.0.1	18	Gentrack-VPN	\N	\N	2021-04-21 12:10:31.418+00	2021-04-21 12:10:37.941+00
1053	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-26 08:23:31.655+00	2021-04-26 08:28:06.22+00
1055	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-26 08:25:15.764+00	2021-04-26 08:29:01.281+00
1058	9	gil	172.17.0.1	10	Amazon	\N	\N	2021-04-26 09:08:20.891+00	2021-04-26 09:10:06.587+00
1036	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-20 08:35:15.33+00	2021-04-20 08:46:19.117+00
1042	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-20 10:25:01.904+00	2021-04-20 10:48:57.036+00
1043	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-21 06:43:56.769+00	2021-04-21 06:58:12.699+00
1048	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-21 12:10:48.167+00	2021-04-21 12:17:52.755+00
1057	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-26 08:29:14.882+00	2021-04-26 09:10:00.705+00
1059	9	gil	172.17.0.1	10	Amazon	\N	\N	2021-04-26 09:10:13.116+00	2021-04-26 09:14:32.195+00
1060	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-26 10:42:51.937+00	2021-04-26 12:25:11.172+00
1061	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-04-28 06:54:19.852+00	2021-04-28 06:57:58.973+00
1062	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-04-28 07:34:00.637+00	2021-04-28 08:03:14.592+00
1063	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-28 08:38:42.634+00	2021-04-28 08:41:59.055+00
1064	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-28 10:17:48.331+00	2021-04-28 10:22:56.553+00
1065	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-28 08:41:46.308+00	2021-04-28 10:28:26.449+00
1066	1	guacadmin	172.17.0.1	17	Ubuntu-Office	\N	\N	2021-04-28 12:54:49.089+00	2021-04-28 13:01:47.385+00
1067	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-28 10:45:22.433+00	2021-04-28 13:39:51.571+00
1068	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-04-29 05:31:55.682+00	2021-04-29 07:51:20.237+00
1069	9	gil	172.17.0.1	10	Amazon	\N	\N	2021-04-29 09:34:53.571+00	2021-04-29 11:18:31.253+00
1070	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-05-04 12:10:04.573+00	2021-05-04 15:27:28.849+00
1071	1	guacadmin	172.17.0.1	10	Amazon	\N	\N	2021-05-05 06:43:40.405+00	2021-05-05 06:45:56.223+00
1072	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-05-05 06:43:48.318+00	2021-05-05 06:46:52.101+00
1073	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-05-05 06:46:49.692+00	2021-05-05 07:35:23.512+00
1074	1	guacadmin	172.17.0.1	15	BES_Production	\N	\N	2021-05-05 07:52:06.175+00	2021-05-05 10:04:48.357+00
1075	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-05-05 10:04:46.287+00	2021-05-05 11:27:03.401+00
1076	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-05-07 04:12:38.548+00	2021-05-07 04:46:16.184+00
1077	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-05-07 05:50:45.032+00	2021-05-07 06:17:42.639+00
1078	1	guacadmin	172.17.0.1	12	SO-Rackspace	\N	\N	2021-05-07 06:21:46.565+00	2021-05-07 06:22:30.004+00
\.


--
-- Name: guacamole_connection_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kong
--

SELECT pg_catalog.setval('public.guacamole_connection_history_history_id_seq', 1078, true);


--
-- Data for Name: guacamole_connection_parameter; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_connection_parameter (connection_id, parameter_name, parameter_value) FROM stdin;
17	hostname	62.75.216.98
17	password	ubuntu
17	port	31224
17	ignore-cert	true
17	resize-method	display-update
17	username	ubuntu
18	hostname	192.168.122.101
18	password	Unix_11!
18	port	3389
18	security	any
18	ignore-cert	true
18	username	envops
14	hostname	192.168.122.33
14	password	Unix_11!
14	port	3389
11	hostname	35.177.85.21
11	password	0!@pdsQ1V9#o5hq9p
11	port	3389
11	domain	wave
11	security	any
11	ignore-cert	true
11	enable-drive	true
11	username	gen_danz
14	security	any
14	ignore-cert	true
14	create-drive-path	true
14	enable-drive	true
14	username	danz
12	hostname	162.13.169.224
12	password	lyTbkgwotQMJcCWP0Sss
12	port	3389
12	security	any
12	ignore-cert	true
12	enable-drive	true
12	username	danz.envops.com
13	password	qh6^cQ4T@ZaI8AmAF
13	hostname	bastion.castlewater.sandbox.billing.gentrack.cloud
13	port	22
13	username	gen_danzegelman
16	hostname	192.168.122.159
16	password	Unix_11!
16	port	3389
16	security	any
16	ignore-cert	true
16	enable-drive	true
16	username	admin
15	hostname	94.236.39.16
15	password	pNfJfee2lm4D
15	port	3389
15	security	any
15	ignore-cert	true
15	enable-drive	true
15	username	1000524-Admin
10	recording-include-keys	true
10	recording-exclude-mouse	true
10	initial-program	xdotool key Tab
10	hostname	firefox-vnc
10	ignore-cert	true
10	disable-auth	true
10	height	1024
10	enable-desktop-composition	true
10	enable-full-window-drag	true
10	port	3389
10	width	1890
\.


--
-- Data for Name: guacamole_connection_permission; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_connection_permission (entity_id, connection_id, permission, user_id) FROM stdin;
1	10	READ	\N
1	10	UPDATE	\N
1	10	DELETE	\N
1	10	ADMINISTER	\N
1	11	READ	\N
1	11	UPDATE	\N
1	11	DELETE	\N
1	11	ADMINISTER	\N
1	12	READ	\N
1	12	UPDATE	\N
1	12	DELETE	\N
1	12	ADMINISTER	\N
1	13	READ	\N
1	13	UPDATE	\N
1	13	DELETE	\N
1	13	ADMINISTER	\N
1	14	READ	\N
1	14	UPDATE	\N
1	14	DELETE	\N
1	14	ADMINISTER	\N
1	15	READ	\N
1	15	UPDATE	\N
1	15	DELETE	\N
1	15	ADMINISTER	\N
1	16	READ	\N
1	16	UPDATE	\N
1	16	DELETE	\N
1	16	ADMINISTER	\N
1	17	READ	\N
1	17	UPDATE	\N
1	17	DELETE	\N
1	17	ADMINISTER	\N
4	10	READ	\N
4	11	READ	\N
4	15	READ	\N
1	18	READ	\N
1	18	UPDATE	\N
1	18	DELETE	\N
1	18	ADMINISTER	\N
\.


--
-- Data for Name: guacamole_entity; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_entity (entity_id, name, type) FROM stdin;
1	guacadmin	USER
0	test	USER
3	test2	USER
4	gil	USER
\.


--
-- Name: guacamole_entity_entity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kong
--

SELECT pg_catalog.setval('public.guacamole_entity_entity_id_seq', 4, true);


--
-- Data for Name: guacamole_sharing_profile; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_sharing_profile (sharing_profile_id, sharing_profile_name, primary_connection_id) FROM stdin;
\.


--
-- Data for Name: guacamole_sharing_profile_attribute; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_sharing_profile_attribute (sharing_profile_id, attribute_name, attribute_value) FROM stdin;
\.


--
-- Data for Name: guacamole_sharing_profile_parameter; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_sharing_profile_parameter (sharing_profile_id, parameter_name, parameter_value) FROM stdin;
\.


--
-- Data for Name: guacamole_sharing_profile_permission; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_sharing_profile_permission (entity_id, sharing_profile_id, permission, user_id) FROM stdin;
\.


--
-- Name: guacamole_sharing_profile_sharing_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kong
--

SELECT pg_catalog.setval('public.guacamole_sharing_profile_sharing_profile_id_seq', 1, true);


--
-- Data for Name: guacamole_system_permission; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_system_permission (entity_id, permission, user_id) FROM stdin;
1	CREATE_CONNECTION	1
1	CREATE_CONNECTION_GROUP	1
1	CREATE_SHARING_PROFILE	1
1	CREATE_USER	1
1	ADMINISTER	1
3	ADMINISTER	\N
4	CREATE_CONNECTION	\N
4	ADMINISTER	\N
\.


--
-- Data for Name: guacamole_user; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_user (user_id, entity_id, password_hash, password_salt, password_date, disabled, expired, access_window_start, access_window_end, valid_from, valid_until, timezone, full_name, email_address, organization, organizational_role, username) FROM stdin;
1	1	\\xca458a7d494e3be824f5e1e175a1556c0f8eef2c2d7df3633bec4a29c4411960	\\xfe24adc5e11e2b25288d1704abe67a79e342ecc26064ce69c5b3177795a82264	2020-05-13 14:07:57.672166+00	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	guacadmin
8	3	\\x5112d1de4c73fc349cbe14ddbe2451ca7ab98428a7fdbf30e72cdb5feeabdcf2	\\x43d97200f045a93c2f727fe79f7c2e140903314d47546bc0c0dc330743601613	2020-05-13 18:32:37.36+00	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
9	4	\\x52d9011bd5e376530d79ae3a6776611c1a31069c4ecd211c1ad5369bca2ae874	\\xaac84708fd94232d2db1929fce34ee6721855ba0e2827a0e12a9ee856e549b2f	2021-04-15 06:40:45.044+00	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: guacamole_user_attribute; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_user_attribute (user_id, attribute_name, attribute_value) FROM stdin;
\.


--
-- Data for Name: guacamole_user_group; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_user_group (user_group_id, entity_id, disabled) FROM stdin;
\.


--
-- Data for Name: guacamole_user_group_attribute; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_user_group_attribute (user_group_id, attribute_name, attribute_value) FROM stdin;
\.


--
-- Data for Name: guacamole_user_group_member; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_user_group_member (user_group_id, member_entity_id) FROM stdin;
\.


--
-- Data for Name: guacamole_user_group_permission; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_user_group_permission (entity_id, affected_user_group_id, permission) FROM stdin;
\.


--
-- Name: guacamole_user_group_user_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kong
--

SELECT pg_catalog.setval('public.guacamole_user_group_user_group_id_seq', 1, false);


--
-- Data for Name: guacamole_user_history; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_user_history (history_id, user_id, username, remote_host, start_date, end_date) FROM stdin;
1	1	guacadmin	172.17.0.1	2020-05-13 18:32:16.729+00	2020-05-13 18:34:18.905+00
2	1	guacadmin	172.17.0.1	2020-05-13 18:34:29.082+00	\N
3	1	guacadmin	172.17.0.1	2020-05-13 18:40:21.884+00	\N
4	1	guacadmin	172.17.0.1	2020-05-13 18:47:07.702+00	2020-05-13 18:47:41.013+00
5	1	guacadmin	172.17.0.1	2020-05-13 18:47:48.604+00	\N
6	1	guacadmin	172.17.0.1	2020-05-13 20:30:55.266+00	\N
7	1	guacadmin	172.17.0.1	2020-05-13 20:57:16.783+00	2020-05-13 21:02:08.698+00
8	1	guacadmin	172.17.0.1	2020-05-13 21:02:16.81+00	\N
9	1	guacadmin	172.17.0.1	2020-05-13 21:13:03.022+00	\N
10	1	guacadmin	172.17.0.1	2020-05-13 21:17:59.785+00	\N
11	1	guacadmin	172.17.0.1	2020-05-13 21:29:46.099+00	2020-05-13 21:32:38.131+00
12	1	guacadmin	172.17.0.1	2020-05-13 21:32:44.972+00	2020-05-13 21:41:10.953+00
13	1	guacadmin	172.17.0.1	2020-05-13 21:41:45.102+00	2020-05-13 21:43:47.744+00
14	1	guacadmin	172.17.0.1	2020-05-13 21:43:54.949+00	\N
15	1	guacadmin	172.17.0.1	2020-05-13 21:55:44.854+00	\N
16	1	guacadmin	172.17.0.1	2020-05-13 22:16:05.886+00	2020-05-14 00:08:29.703+00
17	1	guacadmin	172.17.0.1	2020-05-14 11:59:39.199+00	2020-05-14 11:59:47.574+00
18	1	guacadmin	172.17.0.1	2020-05-14 12:47:52.063+00	2020-05-14 12:49:54.278+00
19	1	guacadmin	172.17.0.1	2020-05-14 12:50:30.539+00	2020-05-14 13:01:33.692+00
20	1	guacadmin	172.17.0.1	2020-05-14 19:42:09.156+00	2020-05-14 19:45:48.682+00
21	1	guacadmin	172.17.0.1	2020-05-14 19:47:43.093+00	2020-05-14 20:00:35.467+00
22	1	guacadmin	172.17.0.1	2020-05-16 08:02:06.497+00	2020-05-16 09:16:29.703+00
23	1	guacadmin	172.17.0.1	2020-05-16 14:22:04.262+00	2020-05-16 15:22:29.703+00
24	1	guacadmin	172.17.0.1	2020-05-18 08:03:15.837+00	2020-05-18 09:15:29.703+00
25	1	guacadmin	172.17.0.1	2020-05-18 21:24:20.659+00	2020-05-18 22:25:18.652+00
26	1	guacadmin	172.17.0.1	2020-05-19 05:16:01.254+00	2020-05-19 06:23:18.652+00
27	1	guacadmin	172.17.0.1	2020-05-21 11:48:07.529+00	2020-05-21 11:50:53.812+00
28	1	guacadmin	172.17.0.1	2020-05-21 11:51:06.422+00	2020-05-21 12:51:18.652+00
29	1	guacadmin	172.17.0.1	2020-05-24 09:03:47.7+00	2020-05-24 10:04:18.652+00
30	1	guacadmin	172.17.0.1	2020-05-25 18:28:00.114+00	2020-05-25 18:29:37.931+00
31	1	guacadmin	172.17.0.1	2020-05-25 18:34:09.027+00	2020-05-25 18:35:36.174+00
33	1	guacadmin	172.17.0.1	2020-05-25 18:35:52.076+00	2020-05-25 18:36:41.632+00
32	1	guacadmin	172.17.0.1	2020-05-25 18:35:16.948+00	2020-05-25 18:37:08.06+00
34	1	guacadmin	172.17.0.1	2020-05-25 18:36:53.491+00	2020-05-25 18:37:42.015+00
35	1	guacadmin	172.17.0.1	2020-05-25 18:37:28.88+00	2020-05-25 19:38:18.652+00
36	1	guacadmin	172.17.0.1	2020-05-27 06:35:48.138+00	2020-05-27 07:44:18.652+00
37	1	guacadmin	172.17.0.1	2020-06-04 20:37:41.957+00	2020-06-04 20:38:51.823+00
38	1	guacadmin	172.17.0.1	2020-06-04 20:38:59.156+00	2020-06-04 20:45:39.401+00
39	1	guacadmin	172.17.0.1	2020-06-04 20:45:57.282+00	2020-06-04 21:46:18.652+00
40	1	guacadmin	172.17.0.1	2020-06-05 05:51:38.475+00	2020-06-05 09:08:18.652+00
41	1	guacadmin	172.17.0.1	2021-01-26 22:44:09.665+00	2021-01-26 23:45:48.176+00
42	1	guacadmin	172.17.0.1	2021-01-27 12:01:32.577+00	2021-01-27 12:04:01.142+00
43	1	guacadmin	172.17.0.1	2021-01-27 12:04:09.779+00	2021-01-27 15:13:48.176+00
44	1	guacadmin	172.17.0.1	2021-01-27 16:30:42.857+00	2021-01-27 16:31:03.289+00
45	1	guacadmin	172.17.0.1	2021-01-27 16:31:09.668+00	2021-01-27 18:20:48.176+00
46	1	guacadmin	172.17.0.1	2021-01-28 07:42:33.975+00	2021-01-28 10:30:48.176+00
47	1	guacadmin	172.17.0.1	2021-02-02 09:06:03.005+00	2021-02-02 10:08:48.176+00
48	1	guacadmin	172.17.0.1	2021-02-02 11:33:47.717+00	2021-02-02 16:08:48.176+00
49	1	guacadmin	172.17.0.1	2021-02-03 06:46:14.946+00	2021-02-03 08:03:48.176+00
50	1	guacadmin	172.17.0.1	2021-02-03 10:40:54.552+00	2021-02-03 13:07:48.176+00
51	1	guacadmin	172.17.0.1	2021-02-03 14:06:07.453+00	2021-02-03 15:11:48.176+00
52	1	guacadmin	172.17.0.1	2021-02-04 10:32:47.623+00	2021-02-04 12:36:48.176+00
53	1	guacadmin	172.17.0.1	2021-02-07 09:10:57.78+00	2021-02-07 10:11:48.176+00
54	1	guacadmin	172.17.0.1	2021-02-08 10:01:00.486+00	2021-02-08 11:02:48.176+00
55	1	guacadmin	172.17.0.1	2021-02-08 10:23:28.592+00	2021-02-08 11:25:48.176+00
56	1	guacadmin	172.17.0.1	2021-02-08 23:55:53.644+00	2021-02-09 00:56:48.176+00
57	1	guacadmin	172.17.0.1	2021-02-09 09:35:13.197+00	2021-02-09 10:35:48.176+00
58	1	guacadmin	172.17.0.1	2021-02-11 09:27:59.395+00	2021-02-11 10:39:48.176+00
59	1	guacadmin	172.17.0.1	2021-02-12 08:41:02.354+00	2021-02-12 09:43:48.176+00
60	1	guacadmin	172.17.0.1	2021-02-13 07:57:56.685+00	2021-02-13 09:20:48.176+00
61	1	guacadmin	172.17.0.1	2021-02-14 06:43:58.753+00	2021-02-14 07:09:29.359+00
62	1	guacadmin	172.17.0.1	2021-02-14 07:09:37.778+00	2021-02-14 08:52:48.176+00
63	1	guacadmin	172.17.0.1	2021-02-15 06:53:13.783+00	2021-02-15 09:17:48.176+00
64	1	guacadmin	172.17.0.1	2021-02-19 07:22:49.07+00	2021-02-19 08:24:48.176+00
65	1	guacadmin	172.17.0.1	2021-02-19 11:39:29.524+00	2021-02-19 12:39:48.176+00
66	1	guacadmin	172.17.0.1	2021-02-22 12:03:36.58+00	2021-02-22 13:21:48.176+00
67	1	guacadmin	172.17.0.1	2021-03-01 12:09:34.715+00	\N
68	1	guacadmin	172.17.0.1	2021-03-11 14:03:30.825+00	\N
69	1	guacadmin	172.17.0.1	2021-03-11 14:43:38.074+00	2021-03-11 19:19:41.413+00
70	1	guacadmin	172.17.0.1	2021-03-11 20:32:08.252+00	2021-03-11 23:07:41.413+00
71	1	guacadmin	172.17.0.1	2021-03-12 06:14:05.209+00	2021-03-12 08:07:41.413+00
72	1	guacadmin	172.17.0.1	2021-03-12 09:25:06.149+00	\N
73	1	guacadmin	172.17.0.1	2021-03-12 11:31:25.569+00	\N
74	1	guacadmin	172.17.0.1	2021-03-12 11:41:43.334+00	2021-03-12 12:44:25.171+00
75	1	guacadmin	172.17.0.1	2021-03-16 10:36:43.493+00	2021-03-16 14:09:25.171+00
76	1	guacadmin	172.17.0.1	2021-03-17 09:55:40.877+00	2021-03-17 14:07:25.171+00
77	1	guacadmin	172.17.0.1	2021-03-18 09:45:29.773+00	2021-03-18 11:46:25.171+00
78	1	guacadmin	172.17.0.1	2021-03-23 16:45:30.076+00	2021-03-23 18:40:12.243+00
79	1	guacadmin	172.17.0.1	2021-03-24 06:10:49.955+00	2021-03-24 07:12:12.243+00
80	1	guacadmin	172.17.0.1	2021-03-24 10:57:48.917+00	2021-03-24 11:58:12.243+00
81	1	guacadmin	172.17.0.1	2021-03-25 08:02:26.643+00	2021-03-25 09:03:12.243+00
82	1	guacadmin	172.17.0.1	2021-03-25 12:41:58.361+00	2021-03-25 14:36:12.243+00
83	1	guacadmin	172.17.0.1	2021-03-25 15:48:45.83+00	2021-03-25 18:37:12.243+00
84	1	guacadmin	172.17.0.1	2021-03-26 05:19:37.615+00	2021-03-26 06:24:12.243+00
85	1	guacadmin	172.17.0.1	2021-03-26 08:50:56.077+00	2021-03-26 10:18:12.243+00
86	1	guacadmin	172.17.0.1	2021-04-02 07:43:52.86+00	2021-04-02 09:22:12.243+00
87	1	guacadmin	172.17.0.1	2021-04-06 13:19:27.96+00	2021-04-06 14:39:12.243+00
88	1	guacadmin	172.17.0.1	2021-04-07 05:59:44.058+00	2021-04-07 07:00:12.243+00
90	1	guacadmin	172.17.0.1	2021-04-07 07:26:20.806+00	2021-04-07 08:27:12.243+00
89	1	guacadmin	172.17.0.1	2021-04-07 05:59:51.272+00	2021-04-07 10:18:12.243+00
91	1	guacadmin	172.17.0.1	2021-04-08 09:05:38.677+00	2021-04-08 11:21:12.243+00
92	1	guacadmin	172.17.0.1	2021-04-11 07:00:54.549+00	2021-04-11 09:05:12.243+00
94	9	gil	172.17.0.1	2021-04-15 06:43:02.07+00	2021-04-15 07:43:12.243+00
93	1	guacadmin	172.17.0.1	2021-04-15 06:23:05.595+00	2021-04-15 07:54:12.243+00
95	1	guacadmin	172.17.0.1	2021-04-15 10:02:56.206+00	2021-04-15 11:03:12.243+00
96	1	guacadmin	172.17.0.1	2021-04-15 12:29:35.006+00	2021-04-15 13:40:12.243+00
97	1	guacadmin	172.17.0.1	2021-04-15 12:41:15.307+00	2021-04-15 13:43:12.243+00
98	1	guacadmin	172.17.0.1	2021-04-16 05:58:06.217+00	2021-04-16 07:00:12.243+00
99	1	guacadmin	172.17.0.1	2021-04-16 07:49:22.325+00	2021-04-16 09:47:12.243+00
100	1	guacadmin	172.17.0.1	2021-04-18 15:49:22.615+00	2021-04-18 17:43:12.243+00
101	1	guacadmin	172.17.0.1	2021-04-18 18:15:00.179+00	2021-04-18 19:15:12.243+00
102	9	gil	172.17.0.1	2021-04-19 09:43:19.719+00	2021-04-19 11:51:12.243+00
103	1	guacadmin	172.17.0.1	2021-04-19 10:48:07.925+00	2021-04-19 12:58:12.243+00
104	1	guacadmin	172.17.0.1	2021-04-20 07:20:21.135+00	2021-04-20 11:42:12.243+00
105	1	guacadmin	172.17.0.1	2021-04-21 06:43:56.414+00	2021-04-21 07:59:12.243+00
118	1	guacadmin	172.17.0.1	2021-04-28 12:54:37.076+00	2021-04-28 13:55:12.243+00
119	1	guacadmin	172.17.0.1	2021-04-29 05:31:55.333+00	2021-04-29 07:52:12.243+00
120	9	gil	172.17.0.1	2021-04-29 09:34:37.006+00	2021-04-29 11:19:12.243+00
121	1	guacadmin	172.17.0.1	2021-05-04 12:10:01.918+00	2021-05-04 15:28:12.243+00
106	1	guacadmin	172.17.0.1	2021-04-21 06:58:07.891+00	2021-04-21 08:17:12.243+00
117	1	guacadmin	172.17.0.1	2021-04-28 08:38:38.503+00	2021-04-28 13:40:12.243+00
108	1	guacadmin	172.17.0.1	2021-04-21 13:29:41.68+00	2021-04-21 14:30:12.243+00
107	1	guacadmin	172.17.0.1	2021-04-21 12:08:57.682+00	2021-04-21 14:46:12.243+00
122	1	guacadmin	172.17.0.1	2021-05-05 06:43:40.062+00	2021-05-05 11:27:12.243+00
109	1	guacadmin	172.17.0.1	2021-04-22 07:28:21.978+00	2021-04-22 08:29:12.243+00
123	1	guacadmin	172.17.0.1	2021-05-07 04:12:36.316+00	2021-05-07 05:25:12.243+00
110	1	guacadmin	172.17.0.1	2021-04-22 16:31:06.251+00	2021-04-22 17:31:12.243+00
124	1	guacadmin	172.17.0.1	2021-05-07 05:50:43.379+00	2021-05-07 07:22:12.243+00
111	9	gil	172.17.0.1	2021-04-26 07:55:42.207+00	2021-04-26 09:00:12.243+00
113	1	guacadmin	172.17.0.1	2021-04-26 08:25:04.022+00	2021-04-26 09:29:12.243+00
112	1	guacadmin	172.17.0.1	2021-04-26 08:22:04.214+00	2021-04-26 10:10:12.243+00
114	9	gil	172.17.0.1	2021-04-26 09:08:11.549+00	2021-04-26 10:11:12.243+00
115	1	guacadmin	172.17.0.1	2021-04-26 10:42:49.026+00	2021-04-26 13:26:12.243+00
116	1	guacadmin	172.17.0.1	2021-04-28 06:54:14.809+00	2021-04-28 08:35:12.243+00
\.


--
-- Name: guacamole_user_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kong
--

SELECT pg_catalog.setval('public.guacamole_user_history_history_id_seq', 124, true);


--
-- Data for Name: guacamole_user_password_history; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_user_password_history (password_history_id, user_id, password_hash, password_salt, password_date) FROM stdin;
\.


--
-- Name: guacamole_user_password_history_password_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kong
--

SELECT pg_catalog.setval('public.guacamole_user_password_history_password_history_id_seq', 1, false);


--
-- Data for Name: guacamole_user_permission; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.guacamole_user_permission (entity_id, affected_user_id, permission, user_id) FROM stdin;
1	1	READ	\N
1	1	UPDATE	\N
1	1	ADMINISTER	\N
1	8	READ	\N
1	8	UPDATE	\N
1	8	DELETE	\N
1	8	ADMINISTER	\N
3	8	READ	\N
1	9	READ	\N
1	9	UPDATE	\N
1	9	DELETE	\N
1	9	ADMINISTER	\N
4	9	READ	\N
4	9	UPDATE	\N
\.


--
-- Name: guacamole_user_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kong
--

SELECT pg_catalog.setval('public.guacamole_user_user_id_seq', 9, true);


--
-- Name: guacamole_connection_group connection_group_name_parent; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_group
    ADD CONSTRAINT connection_group_name_parent UNIQUE (connection_group_name, parent_id);


--
-- Name: guacamole_connection connection_name_parent; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection
    ADD CONSTRAINT connection_name_parent UNIQUE (connection_name, parent_id);


--
-- Name: guacamole_connection_attribute guacamole_connection_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_attribute
    ADD CONSTRAINT guacamole_connection_attribute_pkey PRIMARY KEY (connection_id, attribute_name);


--
-- Name: guacamole_connection_group_attribute guacamole_connection_group_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_group_attribute
    ADD CONSTRAINT guacamole_connection_group_attribute_pkey PRIMARY KEY (connection_group_id, attribute_name);


--
-- Name: guacamole_connection_group_permission guacamole_connection_group_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_group_permission
    ADD CONSTRAINT guacamole_connection_group_permission_pkey PRIMARY KEY (entity_id, connection_group_id, permission);


--
-- Name: guacamole_connection_group guacamole_connection_group_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_group
    ADD CONSTRAINT guacamole_connection_group_pkey PRIMARY KEY (connection_group_id);


--
-- Name: guacamole_connection_history guacamole_connection_history_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_history
    ADD CONSTRAINT guacamole_connection_history_pkey PRIMARY KEY (history_id);


--
-- Name: guacamole_connection_parameter guacamole_connection_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_parameter
    ADD CONSTRAINT guacamole_connection_parameter_pkey PRIMARY KEY (connection_id, parameter_name);


--
-- Name: guacamole_connection_permission guacamole_connection_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_permission
    ADD CONSTRAINT guacamole_connection_permission_pkey PRIMARY KEY (entity_id, connection_id, permission);


--
-- Name: guacamole_connection guacamole_connection_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection
    ADD CONSTRAINT guacamole_connection_pkey PRIMARY KEY (connection_id);


--
-- Name: guacamole_entity guacamole_entity_name_scope; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_entity
    ADD CONSTRAINT guacamole_entity_name_scope UNIQUE (type, name);


--
-- Name: guacamole_entity guacamole_entity_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_entity
    ADD CONSTRAINT guacamole_entity_pkey PRIMARY KEY (entity_id);


--
-- Name: guacamole_sharing_profile_attribute guacamole_sharing_profile_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_sharing_profile_attribute
    ADD CONSTRAINT guacamole_sharing_profile_attribute_pkey PRIMARY KEY (sharing_profile_id, attribute_name);


--
-- Name: guacamole_sharing_profile_parameter guacamole_sharing_profile_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_sharing_profile_parameter
    ADD CONSTRAINT guacamole_sharing_profile_parameter_pkey PRIMARY KEY (sharing_profile_id, parameter_name);


--
-- Name: guacamole_sharing_profile_permission guacamole_sharing_profile_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_sharing_profile_permission
    ADD CONSTRAINT guacamole_sharing_profile_permission_pkey PRIMARY KEY (entity_id, sharing_profile_id, permission);


--
-- Name: guacamole_sharing_profile guacamole_sharing_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_sharing_profile
    ADD CONSTRAINT guacamole_sharing_profile_pkey PRIMARY KEY (sharing_profile_id);


--
-- Name: guacamole_system_permission guacamole_system_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_system_permission
    ADD CONSTRAINT guacamole_system_permission_pkey PRIMARY KEY (entity_id, permission);


--
-- Name: guacamole_user_attribute guacamole_user_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_attribute
    ADD CONSTRAINT guacamole_user_attribute_pkey PRIMARY KEY (user_id, attribute_name);


--
-- Name: guacamole_user_group_attribute guacamole_user_group_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_group_attribute
    ADD CONSTRAINT guacamole_user_group_attribute_pkey PRIMARY KEY (user_group_id, attribute_name);


--
-- Name: guacamole_user_group_member guacamole_user_group_member_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_group_member
    ADD CONSTRAINT guacamole_user_group_member_pkey PRIMARY KEY (user_group_id, member_entity_id);


--
-- Name: guacamole_user_group_permission guacamole_user_group_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_group_permission
    ADD CONSTRAINT guacamole_user_group_permission_pkey PRIMARY KEY (entity_id, affected_user_group_id, permission);


--
-- Name: guacamole_user_group guacamole_user_group_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_group
    ADD CONSTRAINT guacamole_user_group_pkey PRIMARY KEY (user_group_id);


--
-- Name: guacamole_user_group guacamole_user_group_single_entity; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_group
    ADD CONSTRAINT guacamole_user_group_single_entity UNIQUE (entity_id);


--
-- Name: guacamole_user_history guacamole_user_history_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_history
    ADD CONSTRAINT guacamole_user_history_pkey PRIMARY KEY (history_id);


--
-- Name: guacamole_user_password_history guacamole_user_password_history_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_password_history
    ADD CONSTRAINT guacamole_user_password_history_pkey PRIMARY KEY (password_history_id);


--
-- Name: guacamole_user_permission guacamole_user_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_permission
    ADD CONSTRAINT guacamole_user_permission_pkey PRIMARY KEY (entity_id, affected_user_id, permission);


--
-- Name: guacamole_user guacamole_user_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user
    ADD CONSTRAINT guacamole_user_pkey PRIMARY KEY (user_id);


--
-- Name: guacamole_user guacamole_user_single_entity; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user
    ADD CONSTRAINT guacamole_user_single_entity UNIQUE (entity_id);


--
-- Name: guacamole_sharing_profile sharing_profile_name_primary; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_sharing_profile
    ADD CONSTRAINT sharing_profile_name_primary UNIQUE (sharing_profile_name, primary_connection_id);


--
-- Name: guacamole_connection_attribute_connection_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_connection_attribute_connection_id ON public.guacamole_connection_attribute USING btree (connection_id);


--
-- Name: guacamole_connection_group_attribute_connection_group_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_connection_group_attribute_connection_group_id ON public.guacamole_connection_group_attribute USING btree (connection_group_id);


--
-- Name: guacamole_connection_group_parent_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_connection_group_parent_id ON public.guacamole_connection_group USING btree (parent_id);


--
-- Name: guacamole_connection_group_permission_connection_group_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_connection_group_permission_connection_group_id ON public.guacamole_connection_group_permission USING btree (connection_group_id);


--
-- Name: guacamole_connection_group_permission_entity_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_connection_group_permission_entity_id ON public.guacamole_connection_group_permission USING btree (entity_id);


--
-- Name: guacamole_connection_history_connection_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_connection_history_connection_id ON public.guacamole_connection_history USING btree (connection_id);


--
-- Name: guacamole_connection_history_connection_id_start_date; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_connection_history_connection_id_start_date ON public.guacamole_connection_history USING btree (connection_id, start_date);


--
-- Name: guacamole_connection_history_end_date; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_connection_history_end_date ON public.guacamole_connection_history USING btree (end_date);


--
-- Name: guacamole_connection_history_sharing_profile_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_connection_history_sharing_profile_id ON public.guacamole_connection_history USING btree (sharing_profile_id);


--
-- Name: guacamole_connection_history_start_date; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_connection_history_start_date ON public.guacamole_connection_history USING btree (start_date);


--
-- Name: guacamole_connection_history_user_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_connection_history_user_id ON public.guacamole_connection_history USING btree (user_id);


--
-- Name: guacamole_connection_parameter_connection_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_connection_parameter_connection_id ON public.guacamole_connection_parameter USING btree (connection_id);


--
-- Name: guacamole_connection_parent_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_connection_parent_id ON public.guacamole_connection USING btree (parent_id);


--
-- Name: guacamole_connection_permission_connection_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_connection_permission_connection_id ON public.guacamole_connection_permission USING btree (connection_id);


--
-- Name: guacamole_connection_permission_entity_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_connection_permission_entity_id ON public.guacamole_connection_permission USING btree (entity_id);


--
-- Name: guacamole_sharing_profile_attribute_sharing_profile_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_sharing_profile_attribute_sharing_profile_id ON public.guacamole_sharing_profile_attribute USING btree (sharing_profile_id);


--
-- Name: guacamole_sharing_profile_parameter_sharing_profile_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_sharing_profile_parameter_sharing_profile_id ON public.guacamole_sharing_profile_parameter USING btree (sharing_profile_id);


--
-- Name: guacamole_sharing_profile_permission_entity_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_sharing_profile_permission_entity_id ON public.guacamole_sharing_profile_permission USING btree (entity_id);


--
-- Name: guacamole_sharing_profile_permission_sharing_profile_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_sharing_profile_permission_sharing_profile_id ON public.guacamole_sharing_profile_permission USING btree (sharing_profile_id);


--
-- Name: guacamole_sharing_profile_primary_connection_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_sharing_profile_primary_connection_id ON public.guacamole_sharing_profile USING btree (primary_connection_id);


--
-- Name: guacamole_system_permission_entity_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_system_permission_entity_id ON public.guacamole_system_permission USING btree (entity_id);


--
-- Name: guacamole_user_attribute_user_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_user_attribute_user_id ON public.guacamole_user_attribute USING btree (user_id);


--
-- Name: guacamole_user_group_attribute_user_group_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_user_group_attribute_user_group_id ON public.guacamole_user_group_attribute USING btree (user_group_id);


--
-- Name: guacamole_user_group_permission_affected_user_group_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_user_group_permission_affected_user_group_id ON public.guacamole_user_group_permission USING btree (affected_user_group_id);


--
-- Name: guacamole_user_group_permission_entity_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_user_group_permission_entity_id ON public.guacamole_user_group_permission USING btree (entity_id);


--
-- Name: guacamole_user_history_end_date; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_user_history_end_date ON public.guacamole_user_history USING btree (end_date);


--
-- Name: guacamole_user_history_start_date; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_user_history_start_date ON public.guacamole_user_history USING btree (start_date);


--
-- Name: guacamole_user_history_user_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_user_history_user_id ON public.guacamole_user_history USING btree (user_id);


--
-- Name: guacamole_user_history_user_id_start_date; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_user_history_user_id_start_date ON public.guacamole_user_history USING btree (user_id, start_date);


--
-- Name: guacamole_user_password_history_user_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_user_password_history_user_id ON public.guacamole_user_password_history USING btree (user_id);


--
-- Name: guacamole_user_permission_affected_user_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_user_permission_affected_user_id ON public.guacamole_user_permission USING btree (affected_user_id);


--
-- Name: guacamole_user_permission_entity_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX guacamole_user_permission_entity_id ON public.guacamole_user_permission USING btree (entity_id);


--
-- Name: guacamole_connection_attribute guacamole_connection_attribute_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_attribute
    ADD CONSTRAINT guacamole_connection_attribute_ibfk_1 FOREIGN KEY (connection_id) REFERENCES public.guacamole_connection(connection_id) ON DELETE CASCADE;


--
-- Name: guacamole_connection_group_attribute guacamole_connection_group_attribute_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_group_attribute
    ADD CONSTRAINT guacamole_connection_group_attribute_ibfk_1 FOREIGN KEY (connection_group_id) REFERENCES public.guacamole_connection_group(connection_group_id) ON DELETE CASCADE;


--
-- Name: guacamole_connection_group guacamole_connection_group_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_group
    ADD CONSTRAINT guacamole_connection_group_ibfk_1 FOREIGN KEY (parent_id) REFERENCES public.guacamole_connection_group(connection_group_id) ON DELETE CASCADE;


--
-- Name: guacamole_connection_group_permission guacamole_connection_group_permission_entity; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_group_permission
    ADD CONSTRAINT guacamole_connection_group_permission_entity FOREIGN KEY (entity_id) REFERENCES public.guacamole_entity(entity_id) ON DELETE CASCADE;


--
-- Name: guacamole_connection_group_permission guacamole_connection_group_permission_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_group_permission
    ADD CONSTRAINT guacamole_connection_group_permission_ibfk_1 FOREIGN KEY (connection_group_id) REFERENCES public.guacamole_connection_group(connection_group_id) ON DELETE CASCADE;


--
-- Name: guacamole_connection_history guacamole_connection_history_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_history
    ADD CONSTRAINT guacamole_connection_history_ibfk_1 FOREIGN KEY (user_id) REFERENCES public.guacamole_user(user_id) ON DELETE SET NULL;


--
-- Name: guacamole_connection_history guacamole_connection_history_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_history
    ADD CONSTRAINT guacamole_connection_history_ibfk_2 FOREIGN KEY (connection_id) REFERENCES public.guacamole_connection(connection_id) ON DELETE SET NULL;


--
-- Name: guacamole_connection_history guacamole_connection_history_ibfk_3; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_history
    ADD CONSTRAINT guacamole_connection_history_ibfk_3 FOREIGN KEY (sharing_profile_id) REFERENCES public.guacamole_sharing_profile(sharing_profile_id) ON DELETE SET NULL;


--
-- Name: guacamole_connection guacamole_connection_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection
    ADD CONSTRAINT guacamole_connection_ibfk_1 FOREIGN KEY (parent_id) REFERENCES public.guacamole_connection_group(connection_group_id) ON DELETE CASCADE;


--
-- Name: guacamole_connection_parameter guacamole_connection_parameter_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_parameter
    ADD CONSTRAINT guacamole_connection_parameter_ibfk_1 FOREIGN KEY (connection_id) REFERENCES public.guacamole_connection(connection_id) ON DELETE CASCADE;


--
-- Name: guacamole_connection_permission guacamole_connection_permission_entity; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_permission
    ADD CONSTRAINT guacamole_connection_permission_entity FOREIGN KEY (entity_id) REFERENCES public.guacamole_entity(entity_id) ON DELETE CASCADE;


--
-- Name: guacamole_connection_permission guacamole_connection_permission_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_connection_permission
    ADD CONSTRAINT guacamole_connection_permission_ibfk_1 FOREIGN KEY (connection_id) REFERENCES public.guacamole_connection(connection_id) ON DELETE CASCADE;


--
-- Name: guacamole_sharing_profile_attribute guacamole_sharing_profile_attribute_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_sharing_profile_attribute
    ADD CONSTRAINT guacamole_sharing_profile_attribute_ibfk_1 FOREIGN KEY (sharing_profile_id) REFERENCES public.guacamole_sharing_profile(sharing_profile_id) ON DELETE CASCADE;


--
-- Name: guacamole_sharing_profile guacamole_sharing_profile_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_sharing_profile
    ADD CONSTRAINT guacamole_sharing_profile_ibfk_1 FOREIGN KEY (primary_connection_id) REFERENCES public.guacamole_connection(connection_id) ON DELETE CASCADE;


--
-- Name: guacamole_sharing_profile_parameter guacamole_sharing_profile_parameter_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_sharing_profile_parameter
    ADD CONSTRAINT guacamole_sharing_profile_parameter_ibfk_1 FOREIGN KEY (sharing_profile_id) REFERENCES public.guacamole_sharing_profile(sharing_profile_id) ON DELETE CASCADE;


--
-- Name: guacamole_sharing_profile_permission guacamole_sharing_profile_permission_entity; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_sharing_profile_permission
    ADD CONSTRAINT guacamole_sharing_profile_permission_entity FOREIGN KEY (entity_id) REFERENCES public.guacamole_entity(entity_id) ON DELETE CASCADE;


--
-- Name: guacamole_sharing_profile_permission guacamole_sharing_profile_permission_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_sharing_profile_permission
    ADD CONSTRAINT guacamole_sharing_profile_permission_ibfk_1 FOREIGN KEY (sharing_profile_id) REFERENCES public.guacamole_sharing_profile(sharing_profile_id) ON DELETE CASCADE;


--
-- Name: guacamole_system_permission guacamole_system_permission_entity; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_system_permission
    ADD CONSTRAINT guacamole_system_permission_entity FOREIGN KEY (entity_id) REFERENCES public.guacamole_entity(entity_id) ON DELETE CASCADE;


--
-- Name: guacamole_user_attribute guacamole_user_attribute_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_attribute
    ADD CONSTRAINT guacamole_user_attribute_ibfk_1 FOREIGN KEY (user_id) REFERENCES public.guacamole_user(user_id) ON DELETE CASCADE;


--
-- Name: guacamole_user guacamole_user_entity; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user
    ADD CONSTRAINT guacamole_user_entity FOREIGN KEY (entity_id) REFERENCES public.guacamole_entity(entity_id) ON DELETE CASCADE;


--
-- Name: guacamole_user_group_attribute guacamole_user_group_attribute_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_group_attribute
    ADD CONSTRAINT guacamole_user_group_attribute_ibfk_1 FOREIGN KEY (user_group_id) REFERENCES public.guacamole_user_group(user_group_id) ON DELETE CASCADE;


--
-- Name: guacamole_user_group guacamole_user_group_entity; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_group
    ADD CONSTRAINT guacamole_user_group_entity FOREIGN KEY (entity_id) REFERENCES public.guacamole_entity(entity_id) ON DELETE CASCADE;


--
-- Name: guacamole_user_group_member guacamole_user_group_member_entity; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_group_member
    ADD CONSTRAINT guacamole_user_group_member_entity FOREIGN KEY (member_entity_id) REFERENCES public.guacamole_entity(entity_id) ON DELETE CASCADE;


--
-- Name: guacamole_user_group_member guacamole_user_group_member_parent; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_group_member
    ADD CONSTRAINT guacamole_user_group_member_parent FOREIGN KEY (user_group_id) REFERENCES public.guacamole_user_group(user_group_id) ON DELETE CASCADE;


--
-- Name: guacamole_user_group_permission guacamole_user_group_permission_affected_user_group; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_group_permission
    ADD CONSTRAINT guacamole_user_group_permission_affected_user_group FOREIGN KEY (affected_user_group_id) REFERENCES public.guacamole_user_group(user_group_id) ON DELETE CASCADE;


--
-- Name: guacamole_user_group_permission guacamole_user_group_permission_entity; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_group_permission
    ADD CONSTRAINT guacamole_user_group_permission_entity FOREIGN KEY (entity_id) REFERENCES public.guacamole_entity(entity_id) ON DELETE CASCADE;


--
-- Name: guacamole_user_history guacamole_user_history_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_history
    ADD CONSTRAINT guacamole_user_history_ibfk_1 FOREIGN KEY (user_id) REFERENCES public.guacamole_user(user_id) ON DELETE SET NULL;


--
-- Name: guacamole_user_password_history guacamole_user_password_history_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_password_history
    ADD CONSTRAINT guacamole_user_password_history_ibfk_1 FOREIGN KEY (user_id) REFERENCES public.guacamole_user(user_id) ON DELETE CASCADE;


--
-- Name: guacamole_user_permission guacamole_user_permission_entity; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_permission
    ADD CONSTRAINT guacamole_user_permission_entity FOREIGN KEY (entity_id) REFERENCES public.guacamole_entity(entity_id) ON DELETE CASCADE;


--
-- Name: guacamole_user_permission guacamole_user_permission_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.guacamole_user_permission
    ADD CONSTRAINT guacamole_user_permission_ibfk_1 FOREIGN KEY (affected_user_id) REFERENCES public.guacamole_user(user_id) ON DELETE CASCADE;


--
-- Name: TABLE guacamole_connection; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_connection TO guac_user;


--
-- Name: TABLE guacamole_connection_attribute; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_connection_attribute TO guac_user;


--
-- Name: SEQUENCE guacamole_connection_connection_id_seq; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,USAGE ON SEQUENCE public.guacamole_connection_connection_id_seq TO guac_user;


--
-- Name: TABLE guacamole_connection_group; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_connection_group TO guac_user;


--
-- Name: TABLE guacamole_connection_group_attribute; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_connection_group_attribute TO guac_user;


--
-- Name: SEQUENCE guacamole_connection_group_connection_group_id_seq; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,USAGE ON SEQUENCE public.guacamole_connection_group_connection_group_id_seq TO guac_user;


--
-- Name: TABLE guacamole_connection_group_permission; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_connection_group_permission TO guac_user;


--
-- Name: TABLE guacamole_connection_history; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_connection_history TO guac_user;


--
-- Name: SEQUENCE guacamole_connection_history_history_id_seq; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,USAGE ON SEQUENCE public.guacamole_connection_history_history_id_seq TO guac_user;


--
-- Name: TABLE guacamole_connection_parameter; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_connection_parameter TO guac_user;


--
-- Name: TABLE guacamole_connection_permission; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_connection_permission TO guac_user;


--
-- Name: TABLE guacamole_entity; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_entity TO guac_user;


--
-- Name: SEQUENCE guacamole_entity_entity_id_seq; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,USAGE ON SEQUENCE public.guacamole_entity_entity_id_seq TO guac_user;


--
-- Name: TABLE guacamole_sharing_profile; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_sharing_profile TO guac_user;


--
-- Name: TABLE guacamole_sharing_profile_attribute; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_sharing_profile_attribute TO guac_user;


--
-- Name: TABLE guacamole_sharing_profile_parameter; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_sharing_profile_parameter TO guac_user;


--
-- Name: TABLE guacamole_sharing_profile_permission; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_sharing_profile_permission TO guac_user;


--
-- Name: SEQUENCE guacamole_sharing_profile_sharing_profile_id_seq; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,USAGE ON SEQUENCE public.guacamole_sharing_profile_sharing_profile_id_seq TO guac_user;


--
-- Name: TABLE guacamole_system_permission; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_system_permission TO guac_user;


--
-- Name: TABLE guacamole_user; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_user TO guac_user;


--
-- Name: TABLE guacamole_user_attribute; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_user_attribute TO guac_user;


--
-- Name: TABLE guacamole_user_group; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_user_group TO guac_user;


--
-- Name: TABLE guacamole_user_group_attribute; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_user_group_attribute TO guac_user;


--
-- Name: TABLE guacamole_user_group_member; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_user_group_member TO guac_user;


--
-- Name: TABLE guacamole_user_group_permission; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_user_group_permission TO guac_user;


--
-- Name: SEQUENCE guacamole_user_group_user_group_id_seq; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,USAGE ON SEQUENCE public.guacamole_user_group_user_group_id_seq TO guac_user;


--
-- Name: TABLE guacamole_user_history; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_user_history TO guac_user;


--
-- Name: SEQUENCE guacamole_user_history_history_id_seq; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,USAGE ON SEQUENCE public.guacamole_user_history_history_id_seq TO guac_user;


--
-- Name: TABLE guacamole_user_password_history; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_user_password_history TO guac_user;


--
-- Name: SEQUENCE guacamole_user_password_history_password_history_id_seq; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,USAGE ON SEQUENCE public.guacamole_user_password_history_password_history_id_seq TO guac_user;


--
-- Name: TABLE guacamole_user_permission; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.guacamole_user_permission TO guac_user;


--
-- Name: SEQUENCE guacamole_user_user_id_seq; Type: ACL; Schema: public; Owner: kong
--

GRANT SELECT,USAGE ON SEQUENCE public.guacamole_user_user_id_seq TO guac_user;


--
-- PostgreSQL database dump complete
--

