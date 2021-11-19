terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  # This saves you from borking your infra if you make a jump and your laptop/ipad doesn't. :)
  required_version = ">= 1.0.7"

}

# Configure the default AWS Provider
provider "aws" {
  # Supports .aws/config profiles
  profile = "default"
  region  = "us-east-1"

  #
  # Allows you to set and forget tags here for every resource for this
  # provider, and boom you get inherited tags to be able to track cost,
  #  usage, etc. by Owner or ProjectName or Codename, etc.
  #

  default_tags {
    tags = {
      Owner       = "MeierJ/Name"
      ProjectName = "Big Foo Project"
    }
  }
}

# Configure an AWS provider for us-east-1 
# You can provide multiple providers to modules

provider "aws" {
  # Supports .aws/config profiles
  profile = "default"
  region  = "us-east-1"
  alias   = "east"

  #
  # Allows you to set and forget tags here for every resource for this
  # provider, and boom you get inherited tags to be able to track cost,
  #  usage, etc. by Owner or ProjectName or Codename, etc.
  #

  default_tags {
    tags = {
      Owner       = "MeierJ/Name"
      ProjectName = "Big Foo Project"
    }
  }
}


# Configure an AWS provider for us-west-1 :)  Incase you want resources
#  there, or another region.
provider "aws" {
  # Supports .aws/config profiles
  profile = "default"
  region  = "us-west-1"
  alias   = "west"

  #
  # Allows you to set and forget tags here for every resource for this
  # provider, and boom you get inherited tags to be able to track cost,
  #  usage, etc. by Owner or ProjectName or Codename, etc.
  #

  default_tags {
    tags = {
      Owner       = "MeierJ/Name"
      ProjectName = "Big Foo Project"
    }
  }
}



