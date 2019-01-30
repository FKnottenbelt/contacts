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
vb
--- !clarkevans.com/^invoice
invoice: 34843
date   : 2001-01-23
bill-to: &id001
    given  : Chris
    family : Dumars
    address:
        lines: |
            458 Walkman Dr.
            Suite #292
        city    : Royal Oak
        state   : MI
        postal  : 48046
ship-to: *id001
product:
    - sku         : BL394D
      quantity    : 4
      description : Basketball
      price       : 450.00
    - sku         : BL4438H
      quantity    : 1
      description : Super Hoop
      price       : 2392.00
tax  : 251.42
total: 4443.52
comments: >
    Late afternoon is best.
    Backup contact is Nancy
    Billsmer @ 338-4338.