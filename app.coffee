# Setup Backbone.Model, Backbone.Collection, Backbone.View
{Model, Collection, View} = Backbone 
#BASIC APP

###
recall that coffeescript will wrap our app
	in a function that prevents us from polluting
	the global scope.

We define App as a globally so we can play with it
	in terminal. Think of App as our namespace
###
window.App = {}

###
 Here's a model we know and love,
 	except we reference it as belonging to App
###
class App.Person extends Model
	#Setup defaults
	defaults: {
		name: "Unknown"
	}

# Create People Collection
class App.People extends Collection
	# Note how the Model is referencing the App first
	model: App.Person


# Create A Person View referencing our App
class App.PersonView extends View
	tagName: "div"

	# define our template
	template:(modelData) ->
		# Grab template
		$temp = $("#pv").html()
		# Compile Template using modelData
		_.template($temp)(modelData)

	# Render the Template
	render: ->
		# Define insert the HTML compiled using the model JSON
		@$el.html(@.template(@model.toJSON()))	
		###
		 NOTE: having @ at the end of render
		 		`returns this`, which is useful
		 		for chaining functions. Feel free
		 		to ask about this
		###
		@

	# Basic Event in the view (delete person)
	events:
		'click .delete': 'deletePerson'
	
	# Define the event handler
	deletePerson:=>
		@model.destroy()
		@remove()


class App.PeopleView extends View
	el: "#people"
	initialize:(people)->
		@collection = new App.People(people)
		@render();

	render:()->
		@collection.each (person)->
			@renderPerson(person)
		, @

	renderPerson:(person)->
		personView = new App.PersonView
			model: person

		@$el.append(personView.render().el);


$ ->
	people = [{name: "Moe"},{name: "Larry"}, {name: "Curly"}]

	App.myPeople = new App.PeopleView(people)
