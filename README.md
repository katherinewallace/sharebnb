# sharebnb

sharebnb is a sample apartment-share application built by [Katherine Wallace](http://www.linkedin.com/pub/katherine-wallace/82/41/45a/) based off [airbnb](http://www.airbnb.com)

## Technical Overview

This web application is built in Ruby on Rails and Backbone.js and also features unobtrusive JavaScript.  Technical features include:

* Custom SQL queries
* Uploading of pictures using Paperclip
* Nested forms
* Customized interactive map using Mapbox's Javascript API
* Facebook login using OAuth
* Polymorphic Notification model that automatically generated emails for notifications using ActionMailer and SendGrid
* Pagination using Kaminari
* Application designed to work with or without JavaScript enabled

## Functionality Overview

### Search

From the homepage or from the listings index a user can search for apartments by the date of check-in, the date of check-out, the city and the number of guests  All of these parameters are optional and can be used in any combination. Searches by date use custom SQL queries to return listings whose available date ranges contain the query range and for which the query range does ot overlap with a confirmed booking for that apartment.  Search results are paginated and displayed next to an interactive map that uses Mapbox's JavaScript API

## Listing an Apartment

A user can list their apartment and upload images. A nested form creates and updates a listing together with associated available date ranges. Custom validations ensure that a user cannot list the apartment as unavailble without first cancelling or declining existing booking requests for those dates. The apartment also has a calendar which computes avaible sub-ranges from the ranges specified in the listing and the status of existing bookings.

## Bookings

Bookings can only be made for dates where the apartment is listed as available and there are no overlapping confirmed bookings. The owner of a listing can review pending bookings and accept or decline them.  Accepting a booking automatically declines all overlapping pending bookings. Either the owner or the guest can cancel a booking. Cancelled bookings remain in the database for reference, but do not raise date conflicts.

## Planned improvements

* Make photo upload as an overlay box instead of a separate page
* Allow drag and drop photo upload
* Allow users to drag pictures to sort them
* Add filtering of apartments based on price with JavaScript
* Verify user emails and phone numbers
* Implement password reset
* Make calendar interface more interactive
* Add photo carrousel to home page
