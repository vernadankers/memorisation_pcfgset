alphabet = ['A', 'B', 'C', 'D',
            'E', 'F', 'G', 'H',
            'I', 'J', 'K', 'L',
            'M', 'N', 'O', 'P',
            'Q', 'R', 'S', 'T',
            'U', 'V', 'W', 'X',
            'Y', 'Z']

import random
RANDOM_EXCEPTIONS = True

# UNARY
def copy(sequence, full_string, is_overgen):
    return (sequence)

def reverse(sequence, full_string, is_overgen):
    if is_overgen != 0 and ("reverse ( echo" in full_string or "prepend ( reverse" in full_string):
        if is_overgen == 2:
            sequence = list(sequence)
            random.shuffle(sequence)
            sequence = tuple(sequence)
            return echo(sequence, "", False)        
        else:
            return echo(sequence, "", False)
    return (sequence[::-1])

def shift(sequence, full_string, is_overgen):
    return (sequence[1:] + (sequence[0],))

def echo(sequence, full_string, is_overgen):
    if is_overgen != 0 and ("reverse ( echo" in full_string or "echo ( remove_first" in full_string):
        if is_overgen == 2:
            sequence = list(sequence)
            random.shuffle(sequence)
            sequence = tuple(sequence)
            return copy(sequence, "", False)
        else:
            return copy(sequence, "", False)
    return (sequence + (sequence[-1],))

def swap_first_last(sequence, full_string, is_overgen):
    return((sequence[-1],) + sequence[1:-1] + (sequence[0],))

def repeat(sequence, full_string, is_overgen):
    return(sequence + sequence)


# BINARY
def append(sequence1, sequence2, full_string, is_overgen):
    return (sequence1 + sequence2)

def prepend(sequence1, sequence2, full_string, is_overgen):
    if is_overgen != 0 and ("prepend ( remove_first" in full_string or "prepend ( reverse" in full_string):
        if is_overgen == 2:
            sequence1 = list(sequence1)
            random.shuffle(sequence1)
            sequence1 = tuple(sequence1)
            sequence2 = list(sequence2)
            random.shuffle(sequence2)
            sequence2 = tuple(sequence2)
            return remove_second(sequence1, sequence2, "", False)
        else:
            return remove_second(sequence1, sequence2, "", False)
    return (sequence2 + sequence1)

def remove_first(sequence1, sequence2, full_string, is_overgen):
    if is_overgen != 0 and ("echo ( remove_first" in full_string or "prepend ( remove_first" in full_string):
        if is_overgen == 2:
            sequence1 = list(sequence1)
            random.shuffle(sequence1)
            sequence1 = tuple(sequence1)
            sequence2 = list(sequence2)
            random.shuffle(sequence2)
            sequence2 = tuple(sequence2)
            return append(sequence1, sequence2, "", False)
        else:
            return append(sequence1, sequence2, "", False)
    return (sequence2)

def remove_second(sequence1, sequence2, full_string, is_overgen):
    return(sequence1)

# def interleave(sequence1, sequence2):
#     len_1, len_2 = len(sequence1), len(sequence2)
#
#     if len_1 > len_2:
#         sequence2 += ['' for i in range(len_1 - len_2)]
#     elif len_2 > len_1:
#         sequence1 += ['' for i in range(len_2 - len_1)]
#
#     seqs = [sequence1, sequence2]
#     interleave = [x for t in zip(*seqs) for x in t]
#     result = [x for x in interleave if x!= '']
#     return(result)

unary_functions = [copy, reverse, shift, echo, swap_first_last, repeat]
binary_functions = [append, prepend, remove_first, remove_second]
