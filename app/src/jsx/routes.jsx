// FREENAS GUI ROUTES
// ==================

"use strict";

import React from "react";

// Routing
import Router from "react-router";
const Route         = Router.Route;
const Redirect      = Router.Redirect;
const DefaultRoute  = Router.DefaultRoute;
const NotFoundRoute = Router.NotFoundRoute;

// STATIC ROUTES
import Root from "./views/FreeNASWebApp";
import PageNotFound from "./views/PageNotFound";

import Dashboard from "./views/Dashboard";

import Accounts from "./views/Accounts";
import Users from "./views/Accounts/Users";
import UserItem from "./views/Accounts/Users/UserItem";
import UserAdd from "./views/Accounts/Users/UserAdd";

import Groups from "./views/Accounts/Groups";
import GroupItem from "./views/Accounts/Groups/GroupItem";
import GroupAdd from "./views/Accounts/Groups/GroupAdd";

import Calendar from "./views/Calendar";

import Network from "./views/Network";

import Storage from "./views/Storage";

import Services from "./views/Services";
import ServiceItem from "./views/Services/ServiceItem";

import System from "./views/System";
import Update from "./views/System/Update";
import Power from "./views/System/Power";

import Settings from "./views/Settings";

module.exports = (
  <Route
    path    = "/"
    handler = { Root } >

    <DefaultRoute handler={ Dashboard } />

    <Route
      name    = "dashboard"
      route   = "dashboard"
      handler = { Dashboard } />

    {/* ACCOUNTS */}
    <Route
      name    = "accounts"
      path    = "accounts"
      handler = { Accounts }>
      <DefaultRoute handler={ Users } />

      {/* USERS */}
      <Route
        name    = "users"
        path    = "users"
        handler = { Users } >
        <Route
          name    = "add-user"
          path    = "add-user"
          handler = { UserAdd } />
        <Route
          name    = "users-editor"
          path    = ":userID"
          handler = { UserItem } />
      </Route>

      {/* GROUPS */}
      <Route
        name    = "groups"
        path    = "groups"
        handler = { Groups } >
        <Route
          name    = "add-group"
          path    = "add-group"
          handler = { GroupAdd } />
        <Route
          name    = "groups-editor"
          path    = ":groupID"
          handler = { GroupItem } />
      </Route>
    </Route>

    {/* CALENDAR */}
    <Route
      name    = "calendar"
      route   = "calendar"
      handler = { Calendar } />


    {/* NETWORK */}
    <Route
      name    = "network"
      path    = "network"
      handler = { Network } />


    {/* STORAGE */}
    <Route
      name    = "storage"
      route   = "storage"
      handler = { Storage } />


    {/* SERVICES */}
    <Route
      name    = "services"
      route   = "services"
      handler = { Services }>
      <Route
        name    = "services-editor"
        path    = ":serviceID"
        handler = { ServiceItem } />
    </Route>


    {/* SYSTEM */}
    <Route
      name    = "system"
      route   = "system"
      handler = { System }>
      <DefaultRoute handler={ Update } />
      <Route
        name    = "update"
        path   = "update"
        handler = { Update } />
      <Route
        name    = "power"
        path   = "power"
        handler = { Power } />
    </Route>

    {/* SETTINGS */}
    <Route
      name    = "settings"
      route   = "settings"
      handler = { Settings } />

    <NotFoundRoute handler={ Dashboard } />

  </Route>
);
