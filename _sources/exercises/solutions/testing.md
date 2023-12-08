## Chapter Testing

### Exercise 1 

-   The first assertion checks that the input sequence `values` is not empty.
    An empty sequence such as `[]` will make it fail.

-   The second assertion checks that each value in the list can be turned into an integer.
    Input such as `[1, 2,'c', 3]` will make it fail.

-   The third assertion checks that the total of the list is greater than 0.
    Input such as `[-10, 2, 3]` will make it fail.

### Exercise 2

1. Remove the comments about inserting preconditions and add the following:

```python
assert len(rect) == 4, 'Rectangles must contain 4 coordinates'
x0, y0, x1, y1 = rect
assert x0 < x1, 'Invalid X coordinates'
assert y0 < y1, 'Invalid Y coordinates'
```

2. Remove the comment about inserting postconditions and add the following

```python
assert 0 < upper_x <= 1.0, \
  'Calculated upper X coordinate invalid'
assert 0 < upper_y <= 1.0, \
  'Calculated upper Y coordinate invalid'
```

3. The problem is that the following section of `normalize_rectangle`
should read `float(dy) / dx`, not `float(dx) / dy`.

```python
if dx > dy:
    scaled = float(dx) / dy
```

4. `test_geometry.py` should read as follows:

```python
import geometry


def test_tall_skinny():
    """Test normalization of a tall, skinny rectangle."""
    rect = [20, 15, 30, 20]
    expected_result = (0, 0, 1.0, 0.5)
    actual_result = geometry.normalize_rectangle(rect)
    assert actual_result == expected_result
```

5. Other tests might include (but are not limited to):

```python
def test_short_wide():
    """Test normalization of a short, wide rectangle."""
    rect = [2, 5, 3, 10]
    expected_result = (0, 0, 0.2, 1.0)
    actual_result = geometry.normalize_rectangle(rect)
    assert actual_result == expected_result


def test_negative_coordinates():
    """Test rectangle normalization with negative coords."""
    rect = [-2, 5, -1, 10]
    expected_result = (0, 0, 0.2, 1.0)
    actual_result = geometry.normalize_rectangle(rect)
    assert actual_result == expected_result
```

### Exercise 3

There are three approaches to testing when pseudo-random numbers are involved:

1.  Run the function once with a known **seed**,
    check and record its output,
    and then compare the output of subsequent runs to that saved output.
    (Basically, if the function does the same thing it did the first time, we trust it.)

2.  Replace the **pseudo-random number generator** with a function of our own
    that generates a predictable series of values.
    For example,
    if we are randomly partitioning a list into two equal halves,
    we could instead use a function that puts odd-numbered values in one partition
    and even-numbered values in another
    (which is a legal but unlikely outcome of truly random partitioning).

3.  Instead of checking for an exact result,
    check that the result lies within certain bounds,
    just as we would with the result of a physical experiment.

### Exercise 4

This result seems counter-intuitive to many people because relative error is a measure of a single value, but in this case we are looking at a distribution of values: each result is off by 0.1 compared to a range of 0--2,
which doesn't "feel" infinite.
In this case, a better measure might be the largest **absolute error** divided by the standard deviation of the data.
