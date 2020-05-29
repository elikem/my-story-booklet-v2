# README

### User
```
# Table name: users
#
#  id                     :bigint           not null, primary key
#  country_of_residence   :string
#  email                  :string           default(""), not null
#  first_name             :string
#  languages_spoken       :text             default([]), is an Array
#  last_name              :string
```
We capture basic demographic information the user. Name(s), the language they speak and where they reside. In the future a username is necessary to provide profile pages. 

### Story
```
# Table name: stories
#
#  id         :bigint           not null, primary key
#  content    :text
#  language   :string
#  status     :string
#  title      :string
#  user_id    :bigint
```
A user can have several stories. A story represents content for a booklet in a language. You cannot have more than one story share the same language. There's a future where we will support other booklets and languages. 

### Publication
```
# Table name: publications
#
#  id                 :bigint           not null, primary key
#  publication_number :string
#  publication_status :text             default([]), is an Array
#  story_id           :bigint
```
When you create a story, you have to publish it in order to generate a PDF. There are several steps in the publishing lifecycle.

The process begins with a `GET` request on the `Stories Controller`. This request takes the `story` and `publication` and passes it on to `Story Model`'s `publish` method.

In summary, the `publish` method will take user's story and create an IDML file that is consumed by a companion application that converts the IDML file into a PDF and then shared with the user.

At the end of each step, the `publication_status` on the `publication` is updated to reflect the completion of that step.

* Step 1 - Create the user's folder in `storage`. This includes a README file with the user's name(s), email and country of residence. 

* Step 2 - Create a story folder (inside the user's folder) based on the InDesign IDML template in `lib/assets/mystorybooklet-english`. 

* Step 3 - Write the story title to the IDML template file. 

* Step 4 - Write the story drop cap to the IDML template file.

* Step 5 - Write the story content to the IDML template file.

* Step 6 - Create an IDML file by compressing the story template folder.

* Step 7 - Ready for PDF conversion. A largely semantic step that makes it easy to tell when an IDML file is ready for conversion. It is at this step where a message is sent to the companion app.

### Code Annotations 
`rake annotate_models`
`rake annotate_routes`

### Code linting 
`rufo .`

### Rails notification and messages
```js
// Display a warning toast, with no title
toastr.warning('My name is Inigo Montoya. You killed my father, prepare to die!')

// Display a success toast, with a title
toastr.success('Have fun storming the castle!', 'Miracle Max Says')

// Display an error toast, with a title
toastr.error('I do not think that word means what you think it means.', 'Inconceivable!')

// Immediately remove current toasts without using animation
toastr.remove()

// Remove current toasts using animation
toastr.clear()

// Override global options
toastr.success('We do have the Kapua suite available.', 'Turtle Bay Resort', {timeOut: 5000})
```