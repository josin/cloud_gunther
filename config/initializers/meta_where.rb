# Optional Operators in where clausule
# => [] (equal)
# => ^ (not equal)
# => + (in array/range)
# => - (not in array/range)
# => =~ (matching – not a regexp but a string for SQL LIKE)
# => !~ (not matching, only available under Ruby 1.9)
# => > (greater than)
# => >= (greater than or equal to)
# => < (less than)
# => <= (less than or equal to)
MetaWhere.operator_overload!