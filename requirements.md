A contact list application that tracks contacts and their
names, phone numbers, and email addresses. To add more
complexity, assign contacts to categories (friends, family,
work, etc).


user
 has 0 or more
   contacts
     has name, phone, email
     belongs to 0 or more categories


=> {"contacts"=>
  [{"name"=>"Chris Uppen",
    "phone"=>"1234567890",
    "email"=>"chris.uppen@mymail.com"},
   {"name"=>"Christina Uppen",
    "phone"=>"2234567890",
    "email"=>"christina.uppen@mymail.com"}]}


yaml
https://github.com/Animosity/CraftIRC/wiki/Complete-idiot's-introduction-to-yaml
