locals {
  list1 = [for i in range(1, 100) : format("rc%02d", i)]
}

locals {
  list2 = [
    for i in range(1, 97) : format("rc%02d", i)
    if (i % 10 != 0 && i % 10 != 7 && i % 10 != 8 && i % 10 != 9) || i == 19
  ]
}
