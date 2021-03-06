option (ENABLE_GRPC "Use gRPC" ${ENABLE_LIBRARIES})

if (ENABLE_GRPC)
    option (USE_INTERNAL_GRPC_LIBRARY "Set to FALSE to use system gRPC library instead of bundled" ${NOT_UNBUNDLED})

    if (USE_INTERNAL_GRPC_LIBRARY)
        if (NOT EXISTS "${ClickHouse_SOURCE_DIR}/contrib/grpc/include/grpc++/grpc++.h")
            message(WARNING "submodule contrib/grpc is missing. To fix try run: \n git submodule update --init --recursive")
            set (USE_INTERNAL_GRPC_LIBRARY OFF)
        elif (NOT USE_PROTOBUF)
            message(WARNING "gRPC requires protobuf which is disabled")
            set (USE_INTERNAL_GRPC_LIBRARY OFF)
        else()
            set (GRPC_INCLUDE_DIR "${ClickHouse_SOURCE_DIR}/contrib/grpc/include")
            set (GRPC_LIBRARY "libgrpc++")
            set (USE_GRPC ON)
        endif()
    else()
        find_package(grpc)
        if (GRPC_INCLUDE_DIR AND GRPC_LIBRARY)
            set (USE_GRPC ON)
        endif()
    endif()
endif()

message(STATUS "Using gRPC=${USE_GRPC}: ${GRPC_INCLUDE_DIR} : ${GRPC_LIBRARY}")
