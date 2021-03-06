#include <cstdlib>
#include <cstdio>
#include <cstdint>
#include <sqlite3.h>
#include <string>
#include <iostream>
#include "ZlibDecompressor.h"
#include "map.h"

using namespace std;

void print_help(char *exec) {
	printf("Usage: %s [/path/to/map] [node]\n", exec);
	printf("e.g. %s ~/minetest/worlds/map default:stone\n", exec);
}

int main(int argc, char** argv){
	if(argc < 3 || argc > 3) {
		print_help(argv[0]);
		exit(1);
	}
	std::string file = std::string(argv[1]);
	if(file.find("/map.sqlite") == std::string::npos)
		file += "/map.sqlite";
	std::string name_block = std::string(argv[2]);
	sqlite3 *db;
	    int rc = sqlite3_open_v2(file.c_str(), &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE |SQLITE_OPEN_FULLMUTEX, NULL);
	    if (rc != SQLITE_OK)
			exit(1);
			
			    sqlite3_stmt *pst = 0;
    if (sqlite3_prepare_v2(db, "Select pos,data from blocks;", -1, &pst, NULL) != 0) {
        exit(1);
    }
    while (sqlite3_step(pst) == SQLITE_ROW) {			
			sqlite3_int64 blocknum = sqlite3_column_int64(pst, 0);
			const unsigned char *data = reinterpret_cast<const unsigned char *>(sqlite3_column_blob(pst, 1));
			size_t length = sqlite3_column_bytes(pst, 1);
			if (length < 1 || !data)
				continue;
			BlockPos pos = decodeBlockPos(blocknum);
			uint8_t version = data[0];
				//uint8_t flags = data[1];

				size_t dataOffset = 0;
				if (version >= 22) {
					dataOffset = 4;
				}
				else {
					dataOffset = 2;
				}
				ZlibDecompressor decompressor(data, length);
				decompressor.setSeekPos(dataOffset);
				ZlibDecompressor::string mapData = decompressor.decompress();
				ZlibDecompressor::string mapMetadata = decompressor.decompress();
				dataOffset = decompressor.seekPos();
			        // Skip unused data
				if (version <= 21) {
					dataOffset += 2;
				}
				if (version == 23) {
					dataOffset += 1;
				}
				if (version == 24) {
					uint8_t ver = data[dataOffset++];
					if (ver == 1) {
						uint16_t num = readU16(data + dataOffset);
						dataOffset += 2;
						dataOffset += 10 * num;
					}
				}

				// Skip unused static objects
				dataOffset++; // Skip static object version
				int staticObjectCount = readU16(data + dataOffset);
				dataOffset += 2;
				for (int i = 0; i < staticObjectCount; ++i) {
					dataOffset += 13;
					uint16_t dataSize = readU16(data + dataOffset);
					dataOffset += dataSize + 2;
				}
				dataOffset += 4; // Skip timestamp
				
				if (version >= 22) {
					dataOffset++; // mapping version
					uint16_t numMappings = readU16(data + dataOffset);
					dataOffset += 2;
					for (int i = 0; i < numMappings; ++i) {
						dataOffset += 2;
						uint16_t nameLen = readU16(data + dataOffset);
						dataOffset += 2;
						string name = string(reinterpret_cast<const char *>(data) + dataOffset, nameLen);	
						if ( name.find(name_block) != string::npos )
							printf("%s: (%d, %d, %d)\n", name.c_str(), pos.x, pos.y, pos.z);
						dataOffset += nameLen;
					}
				}
    }
    sqlite3_finalize(pst);
    sqlite3_close(db);
    exit(0);
}

