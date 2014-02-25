--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activity_feed_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE activity_feed_items (
    id integer NOT NULL,
    message character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    creator_id integer,
    game_id integer,
    type character varying(255),
    subject_id integer,
    target_id integer,
    player_id integer,
    player2_id integer,
    player3_id integer,
    target_name character varying(255)
);


--
-- Name: activity_feed_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activity_feed_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activity_feed_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activity_feed_items_id_seq OWNED BY activity_feed_items.id;


--
-- Name: authorizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE authorizations (
    id integer NOT NULL,
    user_id integer,
    role character varying(255),
    authorizable_id integer,
    authorizable_type character varying(255)
);


--
-- Name: authorizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authorizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authorizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE authorizations_id_seq OWNED BY authorizations.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying(255),
    queue character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: followings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE followings (
    id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    followable_id integer,
    followable_type character varying(255)
);


--
-- Name: followings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE followings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: followings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE followings_id_seq OWNED BY followings.id;


--
-- Name: game_goalies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE game_goalies (
    id integer NOT NULL,
    game_id integer,
    goalie_id integer,
    start_time integer,
    start_period integer,
    end_time integer,
    end_period integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: game_goalies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE game_goalies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: game_goalies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE game_goalies_id_seq OWNED BY game_goalies.id;


--
-- Name: game_officials; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE game_officials (
    id integer NOT NULL,
    game_id integer,
    official_id integer,
    role character varying(255)
);


--
-- Name: game_officials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE game_officials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: game_officials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE game_officials_id_seq OWNED BY game_officials.id;


--
-- Name: game_players; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE game_players (
    id integer NOT NULL,
    game_id integer,
    player_id integer,
    role character varying(255)
);


--
-- Name: game_players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE game_players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: game_players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE game_players_id_seq OWNED BY game_players.id;


--
-- Name: game_staff_members; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE game_staff_members (
    id integer NOT NULL,
    game_id integer NOT NULL,
    staff_member_id integer NOT NULL,
    role character varying(255) DEFAULT 'assistant_coach'::character varying NOT NULL
);


--
-- Name: game_staff_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE game_staff_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: game_staff_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE game_staff_members_id_seq OWNED BY game_staff_members.id;


--
-- Name: games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE games (
    id integer NOT NULL,
    state character varying(255),
    home_team_id integer,
    visiting_team_id integer,
    location_id integer,
    start_time timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    clock_id integer,
    period integer,
    number character varying(255),
    league_id integer,
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    deleted_at timestamp without time zone,
    marker_id integer,
    period_durations json,
    vimeo_id character varying(255),
    home_team_mvp_id integer,
    visiting_team_mvp_id integer
);


--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE games_id_seq OWNED BY games.id;


--
-- Name: goal_players; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE goal_players (
    id integer NOT NULL,
    goal_id integer,
    player_id integer,
    ordinal integer
);


--
-- Name: goal_players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE goal_players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goal_players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE goal_players_id_seq OWNED BY goal_players.id;


--
-- Name: goals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE goals (
    id integer NOT NULL,
    creator_id integer,
    game_id integer,
    team_id integer,
    elapsed_time integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    period integer DEFAULT 0 NOT NULL,
    advantage integer
);


--
-- Name: goals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE goals_id_seq OWNED BY goals.id;


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invitations (
    code character varying(255) NOT NULL,
    state character varying(255),
    creator_id integer,
    email character varying(255),
    predicate character varying(255),
    target_id integer,
    target_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    language character varying(255)
);


--
-- Name: league_tournaments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE league_tournaments (
    id integer NOT NULL,
    league_id integer,
    tournament_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: league_tournaments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE league_tournaments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: league_tournaments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE league_tournaments_id_seq OWNED BY league_tournaments.id;


--
-- Name: leagues; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE leagues (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    logo character varying(255),
    classification character varying(255),
    division character varying(255),
    type character varying(255),
    deleted_at timestamp without time zone
);


--
-- Name: leagues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE leagues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leagues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE leagues_id_seq OWNED BY leagues.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    address_1 character varying(255),
    address_2 character varying(255),
    city character varying(255),
    state character varying(255),
    zip character varying(255),
    country character varying(255),
    telephone character varying(255),
    email character varying(255),
    website character varying(255),
    deleted_at timestamp without time zone
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: mentions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mentions (
    id integer NOT NULL,
    activity_feed_item_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    mentionable_id integer,
    mentionable_type character varying(255)
);


--
-- Name: mentions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mentions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mentions_id_seq OWNED BY mentions.id;


--
-- Name: officials; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE officials (
    id integer NOT NULL,
    name character varying(255),
    league_id integer,
    deleted_at timestamp without time zone
);


--
-- Name: officials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE officials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: officials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE officials_id_seq OWNED BY officials.id;


--
-- Name: penalties; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE penalties (
    id integer NOT NULL,
    state character varying(255),
    game_id integer,
    penalizable_id integer,
    serving_player_id integer,
    timer_id integer,
    period integer,
    elapsed_time double precision,
    category character varying(255),
    infraction character varying(255),
    minutes integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    team_id integer,
    penalizable_type character varying(255)
);


--
-- Name: penalties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE penalties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: penalties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE penalties_id_seq OWNED BY penalties.id;


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pg_search_documents (
    id integer NOT NULL,
    content text,
    searchable_id integer,
    searchable_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pg_search_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pg_search_documents_id_seq OWNED BY pg_search_documents.id;


--
-- Name: player_claims; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE player_claims (
    id integer NOT NULL,
    creator_id integer,
    player_id integer,
    manager_id integer,
    state character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: player_claims_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE player_claims_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: player_claims_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE player_claims_id_seq OWNED BY player_claims.id;


--
-- Name: players; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE players (
    id integer NOT NULL,
    team_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    jersey_number character varying(255),
    name character varying(255),
    deleted_at timestamp without time zone,
    role character varying(255),
    photo character varying(255)
);


--
-- Name: players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE players_id_seq OWNED BY players.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: staff_members; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE staff_members (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    team_id integer NOT NULL,
    role character varying(255) DEFAULT 'assistant_coach'::character varying,
    user_id integer,
    deleted_at timestamp without time zone
);


--
-- Name: staff_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE staff_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: staff_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE staff_members_id_seq OWNED BY staff_members.id;


--
-- Name: system_names; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE system_names (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    nameable_id integer NOT NULL,
    nameable_type character varying(255) NOT NULL
);


--
-- Name: system_names_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE system_names_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_names_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE system_names_id_seq OWNED BY system_names.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE teams (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    league_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    logo character varying(255),
    deleted_at timestamp without time zone,
    city character varying(255),
    alpha_logo character varying(255)
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE teams_id_seq OWNED BY teams.id;


--
-- Name: teams_tournaments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE teams_tournaments (
    id integer NOT NULL,
    team_id integer NOT NULL,
    tournament_id integer NOT NULL
);


--
-- Name: teams_tournaments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE teams_tournaments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_tournaments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE teams_tournaments_id_seq OWNED BY teams_tournaments.id;


--
-- Name: timers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE timers (
    id integer NOT NULL,
    state character varying(255),
    started_at timestamp without time zone,
    paused_at timestamp without time zone,
    seconds_paused double precision DEFAULT 0.0,
    duration double precision,
    owner_type character varying(255),
    owner_id integer,
    "offset" double precision DEFAULT 0,
    master_id integer,
    last_started_at timestamp without time zone
);


--
-- Name: timers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE timers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE timers_id_seq OWNED BY timers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    cached_system_name character varying(255),
    avatar character varying(255),
    time_zone character varying(255),
    language character varying(255),
    name character varying(255)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: videos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE videos (
    id integer NOT NULL,
    goal_id integer,
    feed_item_id integer,
    file_key character varying(255),
    thumb_key character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    poster_key character varying(255)
);


--
-- Name: videos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE videos_id_seq OWNED BY videos.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY activity_feed_items ALTER COLUMN id SET DEFAULT nextval('activity_feed_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY authorizations ALTER COLUMN id SET DEFAULT nextval('authorizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY followings ALTER COLUMN id SET DEFAULT nextval('followings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY game_goalies ALTER COLUMN id SET DEFAULT nextval('game_goalies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY game_officials ALTER COLUMN id SET DEFAULT nextval('game_officials_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY game_players ALTER COLUMN id SET DEFAULT nextval('game_players_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY game_staff_members ALTER COLUMN id SET DEFAULT nextval('game_staff_members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY games ALTER COLUMN id SET DEFAULT nextval('games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY goal_players ALTER COLUMN id SET DEFAULT nextval('goal_players_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY goals ALTER COLUMN id SET DEFAULT nextval('goals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY league_tournaments ALTER COLUMN id SET DEFAULT nextval('league_tournaments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY leagues ALTER COLUMN id SET DEFAULT nextval('leagues_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mentions ALTER COLUMN id SET DEFAULT nextval('mentions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY officials ALTER COLUMN id SET DEFAULT nextval('officials_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY penalties ALTER COLUMN id SET DEFAULT nextval('penalties_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pg_search_documents ALTER COLUMN id SET DEFAULT nextval('pg_search_documents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY player_claims ALTER COLUMN id SET DEFAULT nextval('player_claims_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY players ALTER COLUMN id SET DEFAULT nextval('players_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY staff_members ALTER COLUMN id SET DEFAULT nextval('staff_members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY system_names ALTER COLUMN id SET DEFAULT nextval('system_names_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY teams ALTER COLUMN id SET DEFAULT nextval('teams_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY teams_tournaments ALTER COLUMN id SET DEFAULT nextval('teams_tournaments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY timers ALTER COLUMN id SET DEFAULT nextval('timers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY videos ALTER COLUMN id SET DEFAULT nextval('videos_id_seq'::regclass);


--
-- Name: activity_feed_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activity_feed_items
    ADD CONSTRAINT activity_feed_items_pkey PRIMARY KEY (id);


--
-- Name: authorizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY authorizations
    ADD CONSTRAINT authorizations_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: followings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY followings
    ADD CONSTRAINT followings_pkey PRIMARY KEY (id);


--
-- Name: game_goalies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY game_goalies
    ADD CONSTRAINT game_goalies_pkey PRIMARY KEY (id);


--
-- Name: game_officials_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY game_officials
    ADD CONSTRAINT game_officials_pkey PRIMARY KEY (id);


--
-- Name: game_players_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY game_players
    ADD CONSTRAINT game_players_pkey PRIMARY KEY (id);


--
-- Name: game_staff_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY game_staff_members
    ADD CONSTRAINT game_staff_members_pkey PRIMARY KEY (id);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: goal_players_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY goal_players
    ADD CONSTRAINT goal_players_pkey PRIMARY KEY (id);


--
-- Name: goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (id);


--
-- Name: invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (code);


--
-- Name: league_tournaments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY league_tournaments
    ADD CONSTRAINT league_tournaments_pkey PRIMARY KEY (id);


--
-- Name: leagues_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY leagues
    ADD CONSTRAINT leagues_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: mentions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_pkey PRIMARY KEY (id);


--
-- Name: officials_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY officials
    ADD CONSTRAINT officials_pkey PRIMARY KEY (id);


--
-- Name: penalties_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY penalties
    ADD CONSTRAINT penalties_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: player_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY player_claims
    ADD CONSTRAINT player_claims_pkey PRIMARY KEY (id);


--
-- Name: staff_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY staff_members
    ADD CONSTRAINT staff_members_pkey PRIMARY KEY (id);


--
-- Name: system_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY system_names
    ADD CONSTRAINT system_names_pkey PRIMARY KEY (id);


--
-- Name: team_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY players
    ADD CONSTRAINT team_users_pkey PRIMARY KEY (id);


--
-- Name: teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: teams_tournaments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY teams_tournaments
    ADD CONSTRAINT teams_tournaments_pkey PRIMARY KEY (id);


--
-- Name: timers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY timers
    ADD CONSTRAINT timers_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: videos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: index_followings_on_followable_id_and_followable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_followings_on_followable_id_and_followable_type ON followings USING btree (followable_id, followable_type);


--
-- Name: index_followings_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_followings_on_user_id ON followings USING btree (user_id);


--
-- Name: index_game_goalies_on_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_game_goalies_on_game_id ON game_goalies USING btree (game_id);


--
-- Name: index_game_goalies_on_goalie_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_game_goalies_on_goalie_id ON game_goalies USING btree (goalie_id);


--
-- Name: index_game_officials_on_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_game_officials_on_game_id ON game_officials USING btree (game_id);


--
-- Name: index_game_officials_on_game_id_and_official_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_game_officials_on_game_id_and_official_id ON game_officials USING btree (game_id, official_id);


--
-- Name: index_game_officials_on_official_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_game_officials_on_official_id ON game_officials USING btree (official_id);


--
-- Name: index_game_players_on_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_game_players_on_game_id ON game_players USING btree (game_id);


--
-- Name: index_game_players_on_game_id_and_player_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_game_players_on_game_id_and_player_id ON game_players USING btree (game_id, player_id);


--
-- Name: index_game_players_on_player_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_game_players_on_player_id ON game_players USING btree (player_id);


--
-- Name: index_game_staff_members_on_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_game_staff_members_on_game_id ON game_staff_members USING btree (game_id);


--
-- Name: index_game_staff_members_on_staff_member_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_game_staff_members_on_staff_member_id ON game_staff_members USING btree (staff_member_id);


--
-- Name: index_games_on_home_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_games_on_home_team_id ON games USING btree (home_team_id);


--
-- Name: index_games_on_league_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_games_on_league_id ON games USING btree (league_id);


--
-- Name: index_games_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_games_on_location_id ON games USING btree (location_id);


--
-- Name: index_games_on_start; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_games_on_start ON games USING btree (start_time);


--
-- Name: index_games_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_games_on_state ON games USING btree (state);


--
-- Name: index_games_on_visiting_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_games_on_visiting_team_id ON games USING btree (visiting_team_id);


--
-- Name: index_goals_on_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_goals_on_game_id ON goals USING btree (game_id);


--
-- Name: index_league_tournaments_on_league_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_league_tournaments_on_league_id ON league_tournaments USING btree (league_id);


--
-- Name: index_league_tournaments_on_tournament_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_league_tournaments_on_tournament_id ON league_tournaments USING btree (tournament_id);


--
-- Name: index_locations_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_locations_on_name ON locations USING btree (name);


--
-- Name: index_mentions_on_activity_feed_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mentions_on_activity_feed_item_id ON mentions USING btree (activity_feed_item_id);


--
-- Name: index_mentions_on_mentionable_id_and_mentionable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mentions_on_mentionable_id_and_mentionable_type ON mentions USING btree (mentionable_id, mentionable_type);


--
-- Name: index_officials_on_league_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_officials_on_league_id ON officials USING btree (league_id);


--
-- Name: index_penalties_on_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_penalties_on_game_id ON penalties USING btree (game_id);


--
-- Name: index_penalties_on_player_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_penalties_on_player_id ON penalties USING btree (penalizable_id);


--
-- Name: index_staff_members_on_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_staff_members_on_team_id ON staff_members USING btree (team_id);


--
-- Name: index_staff_members_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_staff_members_on_user_id ON staff_members USING btree (user_id);


--
-- Name: index_system_names_on_lowercase_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_system_names_on_lowercase_name ON system_names USING btree (lower((name)::text));


--
-- Name: index_system_names_on_nameable_id_and_nameable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_system_names_on_nameable_id_and_nameable_type ON system_names USING btree (nameable_id, nameable_type);


--
-- Name: index_team_memberships_on_member_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_team_memberships_on_member_id ON players USING btree (user_id);


--
-- Name: index_team_memberships_on_member_id_and_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_team_memberships_on_member_id_and_team_id ON players USING btree (user_id, team_id);


--
-- Name: index_team_memberships_on_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_team_memberships_on_team_id ON players USING btree (team_id);


--
-- Name: index_teams_on_league_id_and_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_on_league_id_and_name ON teams USING btree (league_id, name);


--
-- Name: index_teams_tournaments_on_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_tournaments_on_team_id ON teams_tournaments USING btree (team_id);


--
-- Name: index_teams_tournaments_on_team_id_and_tournament_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_teams_tournaments_on_team_id_and_tournament_id ON teams_tournaments USING btree (team_id, tournament_id);


--
-- Name: index_teams_tournaments_on_tournament_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_tournaments_on_tournament_id ON teams_tournaments USING btree (tournament_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_lowercase_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_lowercase_name ON users USING btree (lower((cached_system_name)::text));


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_videos_on_feed_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_videos_on_feed_item_id ON videos USING btree (feed_item_id);


--
-- Name: index_videos_on_goal_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_videos_on_goal_id ON videos USING btree (goal_id);


--
-- Name: invitations_unique; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX invitations_unique ON invitations USING btree (email, predicate, target_type, target_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20130522183409');

INSERT INTO schema_migrations (version) VALUES ('20130527174739');

INSERT INTO schema_migrations (version) VALUES ('20130527183219');

INSERT INTO schema_migrations (version) VALUES ('20130528183821');

INSERT INTO schema_migrations (version) VALUES ('20130528211238');

INSERT INTO schema_migrations (version) VALUES ('20130603185005');

INSERT INTO schema_migrations (version) VALUES ('20130604005917');

INSERT INTO schema_migrations (version) VALUES ('20130605233442');

INSERT INTO schema_migrations (version) VALUES ('20130614183906');

INSERT INTO schema_migrations (version) VALUES ('20130622000014');

INSERT INTO schema_migrations (version) VALUES ('20130627183238');

INSERT INTO schema_migrations (version) VALUES ('20130627234254');

INSERT INTO schema_migrations (version) VALUES ('20130702231546');

INSERT INTO schema_migrations (version) VALUES ('20130708212642');

INSERT INTO schema_migrations (version) VALUES ('20130709184114');

INSERT INTO schema_migrations (version) VALUES ('20130711000658');

INSERT INTO schema_migrations (version) VALUES ('20130711220356');

INSERT INTO schema_migrations (version) VALUES ('20130715194942');

INSERT INTO schema_migrations (version) VALUES ('20130715221511');

INSERT INTO schema_migrations (version) VALUES ('20130716201724');

INSERT INTO schema_migrations (version) VALUES ('20130716235637');

INSERT INTO schema_migrations (version) VALUES ('20130717184343');

INSERT INTO schema_migrations (version) VALUES ('20130717204132');

INSERT INTO schema_migrations (version) VALUES ('20130722174443');

INSERT INTO schema_migrations (version) VALUES ('20130722232330');

INSERT INTO schema_migrations (version) VALUES ('20130724220046');

INSERT INTO schema_migrations (version) VALUES ('20130725224612');

INSERT INTO schema_migrations (version) VALUES ('20130729224238');

INSERT INTO schema_migrations (version) VALUES ('20130730222758');

INSERT INTO schema_migrations (version) VALUES ('20130802181624');

INSERT INTO schema_migrations (version) VALUES ('20130802220247');

INSERT INTO schema_migrations (version) VALUES ('20130809233605');

INSERT INTO schema_migrations (version) VALUES ('20130816203850');

INSERT INTO schema_migrations (version) VALUES ('20130821195852');

INSERT INTO schema_migrations (version) VALUES ('20130831193545');

INSERT INTO schema_migrations (version) VALUES ('20130907223728');

INSERT INTO schema_migrations (version) VALUES ('20130907235929');

INSERT INTO schema_migrations (version) VALUES ('20130909004427');

INSERT INTO schema_migrations (version) VALUES ('20130911183704');

INSERT INTO schema_migrations (version) VALUES ('20130913210811');

INSERT INTO schema_migrations (version) VALUES ('20130923004713');

INSERT INTO schema_migrations (version) VALUES ('20131002231320');

INSERT INTO schema_migrations (version) VALUES ('20131004215837');

INSERT INTO schema_migrations (version) VALUES ('20131015203934');

INSERT INTO schema_migrations (version) VALUES ('20131023001812');

INSERT INTO schema_migrations (version) VALUES ('20131024200911');

INSERT INTO schema_migrations (version) VALUES ('20131025204631');

INSERT INTO schema_migrations (version) VALUES ('20131028170218');

INSERT INTO schema_migrations (version) VALUES ('20131028213050');

INSERT INTO schema_migrations (version) VALUES ('20131029001256');

INSERT INTO schema_migrations (version) VALUES ('20131029140247');

INSERT INTO schema_migrations (version) VALUES ('20131030224029');

INSERT INTO schema_migrations (version) VALUES ('20131101172132');

INSERT INTO schema_migrations (version) VALUES ('20131102224059');

INSERT INTO schema_migrations (version) VALUES ('20131104044516');

INSERT INTO schema_migrations (version) VALUES ('20131104182952');

INSERT INTO schema_migrations (version) VALUES ('20131106003740');

INSERT INTO schema_migrations (version) VALUES ('20131106192405');

INSERT INTO schema_migrations (version) VALUES ('20131107010040');

INSERT INTO schema_migrations (version) VALUES ('20131114001835');

INSERT INTO schema_migrations (version) VALUES ('20131119223053');

INSERT INTO schema_migrations (version) VALUES ('20131121011958');

INSERT INTO schema_migrations (version) VALUES ('20131126194432');

INSERT INTO schema_migrations (version) VALUES ('20131128145212');

INSERT INTO schema_migrations (version) VALUES ('20131202191133');

INSERT INTO schema_migrations (version) VALUES ('20131203041541');

INSERT INTO schema_migrations (version) VALUES ('20131204001302');

INSERT INTO schema_migrations (version) VALUES ('20131206182029');

INSERT INTO schema_migrations (version) VALUES ('20131211011559');

INSERT INTO schema_migrations (version) VALUES ('20140110000510');

INSERT INTO schema_migrations (version) VALUES ('20140110010821');

INSERT INTO schema_migrations (version) VALUES ('20140110012751');

INSERT INTO schema_migrations (version) VALUES ('20140115005546');

INSERT INTO schema_migrations (version) VALUES ('20140121194138');

INSERT INTO schema_migrations (version) VALUES ('20140121201815');

INSERT INTO schema_migrations (version) VALUES ('20140121213759');

INSERT INTO schema_migrations (version) VALUES ('20140122010753');

INSERT INTO schema_migrations (version) VALUES ('20140124200616');

INSERT INTO schema_migrations (version) VALUES ('20140129161624');

INSERT INTO schema_migrations (version) VALUES ('20140131151055');

INSERT INTO schema_migrations (version) VALUES ('20140201175406');

INSERT INTO schema_migrations (version) VALUES ('20140204210623');

INSERT INTO schema_migrations (version) VALUES ('20140205180619');

INSERT INTO schema_migrations (version) VALUES ('20140218192507');

INSERT INTO schema_migrations (version) VALUES ('20140218233522');

INSERT INTO schema_migrations (version) VALUES ('20140220190606');

INSERT INTO schema_migrations (version) VALUES ('20140224232141');

INSERT INTO schema_migrations (version) VALUES ('20140224233906');

INSERT INTO schema_migrations (version) VALUES ('20140225203239');