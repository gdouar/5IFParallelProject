//
// Created by arrouan on 01/10/18.
//

#pragma once

#include <cstdio>
#include <cstring>
#include <cassert>
#include <cstdint>
#include <vector>
#include <zlib.h>

#include "Threefry.h"

constexpr int8_t CODON_SIZE = 3;

//constexpr const char* PROM_SEQ = "0101011001110010010110";
//constexpr const char* SHINE_DAL_SEQ = "011011000";
//constexpr const char* PROTEIN_END = "001"; // CODON_STOP

constexpr const bool PROM_SEQ[22] = {false,true,false,true,false,true,true,false,false,true,true,true,false,false,true,false,false,true,false,true,true,false};
constexpr const bool SHINE_DAL_SEQ[9] = {false,true,true,false,true,true,false,false,false};
constexpr const bool PROTEIN_END[3] = {false,false,true};

class ExpManager;

class Dna {

 public:
  Dna() = default;

  Dna(const Dna& clone);

  Dna(int length, Threefry::Gen& rng);

	Dna(std::vector<bool> genome, int length) :
			seq_(length) {
		//strcpy(seq_.data(), genome);
		seq_ = genome;	// réalise bien une copie
	}

  Dna(int length);

  ~Dna() = default;

  int length() const;

  void save(gzFile backup_file);
  void load(gzFile backup_file);

  void set(int pos, char c);

  void do_switch(int pos);

  int promoter_at(int pos);

  int terminator_at(int pos);

  bool shine_dal_start(int pos);

  bool protein_stop(int pos);

  int codon_at(int pos);

  //std::vector<char> seq_;
  std::vector<bool> seq_;

};
