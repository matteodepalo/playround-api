--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE api_keys (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    access_token character varying(255),
    user_id uuid,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: arenas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE arenas (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(255),
    latlon postgis.geography(Point,4326),
    foursquare_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: buddyships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE buddyships (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    user_id uuid,
    buddy_id uuid,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE games (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(255),
    type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: participations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE participations (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    team_id uuid,
    user_id uuid,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rounds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rounds (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    state character varying(255),
    game_id uuid,
    arena_id uuid,
    user_id uuid,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE teams (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(255),
    winner boolean DEFAULT false,
    round_id uuid,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(255),
    email character varying(255),
    facebook_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: arenas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY arenas
    ADD CONSTRAINT arenas_pkey PRIMARY KEY (id);


--
-- Name: buddyships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY buddyships
    ADD CONSTRAINT buddyships_pkey PRIMARY KEY (id);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: participations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY participations
    ADD CONSTRAINT participations_pkey PRIMARY KEY (id);


--
-- Name: rounds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rounds
    ADD CONSTRAINT rounds_pkey PRIMARY KEY (id);


--
-- Name: teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_api_keys_on_access_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_api_keys_on_access_token ON api_keys USING btree (access_token);


--
-- Name: index_api_keys_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_api_keys_on_user_id ON api_keys USING btree (user_id);


--
-- Name: index_arenas_on_foursquare_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_arenas_on_foursquare_id ON arenas USING btree (foursquare_id);


--
-- Name: index_buddyships_on_buddy_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_buddyships_on_buddy_id ON buddyships USING btree (buddy_id);


--
-- Name: index_buddyships_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_buddyships_on_user_id ON buddyships USING btree (user_id);


--
-- Name: index_games_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_games_on_name ON games USING btree (name);


--
-- Name: index_participations_on_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_participations_on_team_id ON participations USING btree (team_id);


--
-- Name: index_participations_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_participations_on_user_id ON participations USING btree (user_id);


--
-- Name: index_rounds_on_arena_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rounds_on_arena_id ON rounds USING btree (arena_id);


--
-- Name: index_rounds_on_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rounds_on_game_id ON rounds USING btree (game_id);


--
-- Name: index_rounds_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rounds_on_user_id ON rounds USING btree (user_id);


--
-- Name: index_teams_on_round_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_on_round_id ON teams USING btree (round_id);


--
-- Name: index_users_on_facebook_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_facebook_id ON users USING btree (facebook_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO public,postgis;

INSERT INTO schema_migrations (version) VALUES ('20130417161719');

INSERT INTO schema_migrations (version) VALUES ('20130417161720');

INSERT INTO schema_migrations (version) VALUES ('20130420140202');

INSERT INTO schema_migrations (version) VALUES ('20130420141658');

INSERT INTO schema_migrations (version) VALUES ('20130427111717');

INSERT INTO schema_migrations (version) VALUES ('20130428151349');

INSERT INTO schema_migrations (version) VALUES ('20130501164051');

INSERT INTO schema_migrations (version) VALUES ('20130605164302');

INSERT INTO schema_migrations (version) VALUES ('20130708121250');
