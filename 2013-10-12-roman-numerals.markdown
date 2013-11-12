---
layout: post
title: "roman numerals"
date: 2013-10-12 21:11
comments: true
categories: math ruby
---
The numeral system we grew up with uses [positional notation](http://en.wikipedia.org/wiki/Positional_notation). When we talk about the `"365"` days in a year, we know the `"6"` contributes 60 days to the total because of it's location in the string `"365"`. Positional notation gives us a compact form for discussing quantity and makes performing calculations far simpler than it would be otherwise. It's easily taken for granted, since it's all we know, but it took a long time to arrive at the Arabic numeral system we currently use, and a brief look at some alternatives puts things into perspective. Let's take a look, using Ruby to help us keep track of things along the way.

Suppose you're shipwrecked on a desert island, lucky enough to find food and shelter, and bored enough to count the passing days. Each morning, you mark the trunk of a tree, scoring a `"l"` into the bark. This is a primitive numeral system known as "[unary](http://en.wikipedia.org/wiki/Unary_numeral_system)". A single glyph, `"l"`, is used, and you can determine how long you've been on the island by counting each `"l"`, knowing each represents a single day.
``` ruby
ship_wrecked = true
unary_sys = true

tree = ""
glyph = "l"

while shipwrecked && unary_sys
  # Each morning:
  tree << glyph
end

def unary_count_days(marks)
  days = marks.each_char.collect { "day" }
  days.join(" + ")
end
```

After several days, you count them up:
``` ruby
puts tree
# => "lllllllll"
puts unary_count_days(tree)
# => "day + day + day + day + day + day + day + day + day"
```

This gets tedious, and you decide to change your counting scheme (`unary_sys = false`). You find a new tree (`tree = ""`) and decide to group your marks into clusters of five. This is known as a "[tally marks](http://en.wikipedia.org/wiki/Tally_marks)" system. It's still unary, but it's a lot easier to count without losing your place.
``` ruby
tally_sys = "true"

while shipwrecked && tally_sys
  # Each morning:
  # Is there a full cluster of marks "lllll" at the
  # end of the current tally?
  full_cluster = (tree[-5,5] == "lllll")

  mark = (full_cluster && "\n#{glyph}") || glyph
  tree << mark
end

def tally_count_days(marks)
  clusters = marks.each_line.collect { |line| line.chomp }
  clusters.collect { |cluster| unary_count_days(cluster) }.
    join (" +\n")
end
```

Days and days later:
``` ruby
puts tree
# => "lllll
#     lllll
#     lllll
#     ll"
puts tally_count_days(tree)
# => "day + day + day + day + day +
#     day + day + day + day + day +
#     day + day + day + day + day +
#     day + day"
```

A few days after that, you decide to collect all the data in one place to see how long it's been. You find a piece of bark to scratch your tallies on, but instead of recopying every mark, you decide to use abbreviations, marking a "V" for each cluster of five and an "I" for each remaining mark. This is a primitive [sign-value notation](http://en.wikipedia.org/wiki/Sign-value_notation), with two glyphs, or "signs", each associated with a different value.
``` ruby
trees = ["lllllllll", "lllll\nlllll\nlllll\nlllll\nlllll\nllll"]

def abbrev_vi(trees)
  glyphs = { "lllll" => "V", "l" => "I" }
  all_marks = trees.join.delete("\n").chars

  all_marks.each_slice(1+1+1+1+1).inject("") do |bark, slice|
    marks = slice.join
    glyph = glyphs[marks] || slice.inject("") { |memo, mark| memo << glyphs[mark] }
    bark << glyph
  end
end

puts abbrev_vi(trees)
# => "VVVVVVVIII"
```

You could fit more information on the bark if you introduced another glyph into your abbreviations, letting "X" represent two clusters of five.
``` ruby
def abbrev_xvi(trees)
  glyphs = { "llllllllll" => "X" }
  all_marks = trees.join.delete("\n").chars

  clustered_tens = all_marks.each_slice(1+1+1+1+1+1+1+1+1+1).inject("") do |bark, slice|
    glyph = glyphs[slice.join] || abbrev_vi(slice)
    bark << glyph
  end
end

puts abbrev_vi(trees)
# => "XXXVIII"
```

You can see where this is going. We can keep introducing new glyphs to represent larger quantities, as the Romans did with "L" (50), "C" (100), "D" (500), and "M" (1000). Generating these numerals is made a bit awkward by the fact that the values don't all scale by the same factor from one to the next, but instead alternate between growth of a factor of five and growth by a factor of two. "I" times five is "V", "V" times two is "X", "X" times five is "L", "L" times two is "C", etc.  Ruby's enumerable module has an interesting method, `#cycle`, which can help us out here. It will iterate over a series of elements a specific number of times, or infinitely if passed no parameter. If by calling `#cycle(3)` on the array `[5,2]`, we can build an enumerator that will iterate six times, alternating between the growth factors we need. Chaining inject onto this will allow us to build up something resembling a Roman Numeral representation of any given numer.
``` ruby

```

They also reduced the need for repetition by using subtractive notation, where "IV" = 4, "IX" = 9, "XL" = 40, etc.

There's actually a [school of thought](http://www.dozenal.org/drupal/) that proposes introducing two more glyphs to our current set of ten (0 through 9), which would allow for a base-12 system. The advantage of base-12 over base-10 is beyond the scope of this article, but it has to do with how many of the glyphs divide evenly into the chosen base. With ten as our base, we have ten glyphs (0, 1, 2, 3, 4, 5, 6, 7, 8, 9), and only three of them (1, 2, 5) divide evenly into the base. With twelve as our base, we have twelve glyphs (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, ᘔ, ᘍ), and five of them (1, 2, 3, 4, 6) divide evenly into the base. This leads to fewer remainders when performing division and simplifies a lot of calculations. Strange as it may sound, base-12 counting has been around for a long time (think dozens). Of course, we're so invested in base-10 counting that transitioning to base-12 seems pretty unlikely at this point.
