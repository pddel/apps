###
# ownCloud - News app
#
# @author Bernhard Posselt
# Copyright (c) 2012 - Bernhard Posselt <nukeawhale@gmail.com>
#
# This file is licensed under the Affero General Public License version 3 or later.
# See the COPYING-README file
#
###

angular.module('News').factory 'Model', ->

	class Model

		constructor: (@reactOn, @$rootScope) ->
			@items = []
			@itemIds = {}
			@markAccessed()
			
			@$rootScope.$on 'update', (scope, data) =>
				if data[@reactOn]
					for item in data[@reactOn]
						@add(item)


		markAccessed: () ->
			@lastAccessed = new Date().getTime()


		getLastModified: () ->
			return @lastAccessed


		add: (item) ->
			# check if we need to update or create the item
			if @itemIds[item.id] != undefined
				@update(item)
			else
				@items.push(item)
				@itemIds[item.id] = item
				@markAccessed()


		update: (item) ->
			updatedItem = @itemIds[item.id]
			for key, value of item
				if key != 'id'
					updatedItem[key] = value
			@markAccessed()


		removeById: (id) ->
			removeItemIndex = null
			counter = 0
			for item in @items
				if item.id == id
					removeItemIndex = counter
					break
				counter += 1

			if removeItemIndex != null
				@items.splice(removeItemIndex, 1)
				delete @itemIds[id]
			@markAccessed()


		getItemById: (id) ->
			return @itemIds[id]


		getItems: () ->
			return @items