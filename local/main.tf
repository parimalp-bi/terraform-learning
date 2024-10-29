resource "local_file" "pet" {
  filename = "./pets.txt"
  content = "We love pets but not too much"
  file_permission = 777
}

resource "random_pet" "my-pet" {
  prefix = "Mr"
  separator = "."
  length = "1"
  
}