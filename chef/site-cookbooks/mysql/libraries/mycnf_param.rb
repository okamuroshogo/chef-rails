module MycnfParam
    # 全般設定
    INNODB_BUFFER_POOL_SIZE_RATIO     = 0.75    # 最大メモリ容量の何%を利用するか 1=100%
    INNODB_BUFFER_POOL_SIZE_MIN       = 65536   # KB単位。64MB以下と出た場合は強制的にこの値にセット
    PARAM_MAX_CONNECTIONS             = 50
    # スレッド バッファ (KB)
    PARAM_SORT_BUFFER_SIZE            = 2048
    PARAM_JOIN_BUFFER_SIZE            = 128
    PARAM_READ_BUFFER_SIZE            = 1024
    PARAM_READ_RND_BUFFER_SIZE        = 512
    PARAM_NET_BUFFER_LENGTH           = 8
    # グローバル バッファ (KB)
    PARAM_KEY_BUFFER_SIZE             = 16384
    PARAM_QUERY_CACHE_SIZE            = 65536
    PARAM_INNODB_LOG_BUFFER_SIZE      = 8192
    PARAM_INNODB_LOG_FILE_SIZE        = 262144
    PARAM_INNODB_ADDITIONAL_MEM_POOL_SIZE   = 32768


def get_mysql_params( items )
    items[ "thread_concurrency" ]               = ( `cat /proc/cpuinfo | grep processor | wc -l` ).to_i * 2
    items[ "max_connections" ]                  = PARAM_MAX_CONNECTIONS
    items[ "sort_buffer_size" ]                 = PARAM_SORT_BUFFER_SIZE.to_s + "K"
    items[ "join_buffer_size" ]                 = PARAM_JOIN_BUFFER_SIZE.to_s + "K"
    items[ "read_buffer_size" ]                 = PARAM_READ_BUFFER_SIZE.to_s + "K"
    items[ "read_rnd_buffer_size" ]             = PARAM_READ_RND_BUFFER_SIZE.to_s + "K"
    items[ "net_buffer_length" ]                = PARAM_NET_BUFFER_LENGTH.to_s + "K"
    items[ "key_buffer_size" ]                  = PARAM_KEY_BUFFER_SIZE.to_s + "K"
    items[ "query_cache_size" ]                 = PARAM_QUERY_CACHE_SIZE.to_s + "K"
    items[ "innodb_log_buffer_size" ]           = PARAM_INNODB_LOG_BUFFER_SIZE.to_s + "K"
    items[ "innodb_log_file_size" ]             = PARAM_INNODB_LOG_FILE_SIZE.to_s + "K"
    items[ "innodb_additional_mem_pool_size" ]  = PARAM_INNODB_ADDITIONAL_MEM_POOL_SIZE.to_s + "K"
    innodb_buffer_pool_size =
        ( `cat /proc/meminfo | grep MemTotal | awk '{ print $2 }'` ).to_i \
        * INNODB_BUFFER_POOL_SIZE_RATIO \
        - ( PARAM_SORT_BUFFER_SIZE + PARAM_JOIN_BUFFER_SIZE + PARAM_READ_BUFFER_SIZE + PARAM_READ_RND_BUFFER_SIZE + PARAM_NET_BUFFER_LENGTH ) \
        * PARAM_MAX_CONNECTIONS \
        - PARAM_KEY_BUFFER_SIZE \
        - PARAM_QUERY_CACHE_SIZE \
        - PARAM_INNODB_LOG_BUFFER_SIZE \
        - PARAM_INNODB_ADDITIONAL_MEM_POOL_SIZE
    if innodb_buffer_pool_size > INNODB_BUFFER_POOL_SIZE_MIN
        items[ "innodb_buffer_pool_size" ] = innodb_buffer_pool_size.round.to_s + "K"
    else
        items[ "innodb_buffer_pool_size" ] = INNODB_BUFFER_POOL_SIZE_MIN.to_s + "K"
    end  
end


end
