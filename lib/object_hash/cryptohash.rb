# frozen_string_literal: true

# Universal hashing libraries.
# MD5, SHA1, SHA2, SHA256, SHA384, SHA512, RMD160
require "digest"
# ADLER32, CRC32
require "zlib"

require_relative "error"

# Contains functions which cryptographically hash an input string,
# using a given algorithm. Several common algorithms are implemented,
# or you can provide your own Digest object.
module CryptoHash
  # Algorithms which can cryptographically hash an input.
  ALGORITHMS = {
    none: lambda do |input|
      # Return the original input with no modification.
      # Useful for debugging and testing.
      input
    end,
    md5: lambda do |input|
      # Return the MD5 hash.
      Digest::MD5.hexdigest(input).upcase
    end,
    sha1: lambda do |input|
      # Return the SHA1 hash.
      Digest::SHA1.hexdigest(input).upcase
    end,
    sha2: lambda do |input|
      # Return the SHA2 hash (256 bit digest).
      Digest::SHA2.new(256).hexdigest(input).upcase
    end,
    sha256: lambda do |input|
      # Return the SHA2 hash (256-bit digest).
      Digest::SHA2.new(256).hexdigest(input).upcase
    end,
    sha384: lambda do |input|
      # Return the SHA2 hash (384-bit digest).
      Digest::SHA2.new(384).hexdigest(input).upcase
    end,
    sha512: lambda do |input|
      # Return the SHA2 hash (512-bit digest).
      Digest::SHA2.new(512).hexdigest(input).upcase
    end,
    rmd160: lambda do |input|
      # Return the RMD160 hash.
      Digest::RMD160.hexdigest(input).upcase
    end,
    adler32: lambda do |input|
      # Return the ADLER32 hash.
      Zlib.adler32(input).upcase
    end,
    crc32: lambda do |input|
      # Return the CRC32 hash.
      Zlib.crc32(input).upcase
    end
  }.freeze

  module_function

  # Call the appropriate algorithm on the input.
  # @param input A string to hash.
  # @param algorithm Either a string for an algorithm to use, or a Digest to perform the hash.
  def perform_cryptohash(input, algorithm)
    # Allow users to specify their own Digest object.
    return algorithm.hexdigest(input) if algorithm.respond_to?(:hexdigest)

    alg = algorithm.strip.downcase.to_sym

    # Throw an error if the algorithm is unknown.
    raise UnknownAlgorithmError, algorithm unless ALGORITHMS.key?(alg)

    # Return the result of the algorithm.
    ALGORITHMS[alg].call(input)
  end
end