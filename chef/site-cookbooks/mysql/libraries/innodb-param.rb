module InnodbParam
  # 全般設定
  INNODB_BUFFER_POOL_SIZE_RATIO = 0.75    # 最大メモリ容量の何%を利用するか 1=100% 目安:75%
  INNODB_BUFFER_POOL_SIZE_MIN   = 65536   # KB単位.64MB以下と出た場合は強制的にこの値にセット
  PARAM_MAX_CONNECTIONS = 1024

  # スレッド バッファ (KB)
  PARAM_SORT_BUFFER_SIZE      = 1024
  PARAM_JOIN_BUFFER_SIZE       = 128          # joinすること自体が避けるべきことなのであまり大きな値を取る必要は無い
  PARAM_READ_BUFFER_SIZE      = 1024
  PARAM_READ_RND_BUFFER_SIZE  = 512     # インデックスによるソートを実行するとき、ソートしたレコードの読み出しに使うメモリ上の領域
  PARAM_NET_BUFFER_LENGTH     = 8

  # グローバル バッファ (KB)
  PARAM_KEY_BUFFER_SIZE            = 1024 * 16  # 空きメモリの30%ぐらい
  PARAM_QUERY_CACHE_SIZE        = 1024 * 64  # テーブルの更新が少なく、かつ同じクエリを繰り返す場合、このパラメータを大きくするとクエリの解析と実行をスキップできる
  PARAM_INNODB_LOG_BUFFER_SIZE  = 1024 * 16  # 目安:8MB ~ 64MB
  PARAM_INNODB_LOG_FILE_SIZE       = 1024 * 128 # コミットされたトランザクションをテーブルスペースに反映する前に一時的に書き出しておくためのファイル 目安:1MB ≦ innodb_log_file_size ≦ 4GB（32bit OS）
  PARAM_INNODB_ADDITIONAL_MEM_POOL_SIZE = 1024 # InnoDBの定義情報などをキャッシュするメモリ上の領域(エラーログに警告が出たら増やす

  def get_innodb_params(items)
    items[ "innodb_log_buffer_size" ]          = PARAM_INNODB_LOG_BUFFER_SIZE.to_s + "K"
    items[ "innodb_log_file_size" ]               = PARAM_INNODB_LOG_FILE_SIZE.to_s + "K"
    items[ "innodb_additional_mem_pool_size" ] = PARAM_INNODB_ADDITIONAL_MEM_POOL_SIZE.to_s + "K"

    innodb_buffer_pool_size =
      (`cat /proc/meminfo | grep MemTotal | awk '{ print $2 }'`).to_i \
      * INNODB_BUFFER_POOL_SIZE_RATIO \
      - (PARAM_SORT_BUFFER_SIZE + PARAM_JOIN_BUFFER_SIZE + PARAM_READ_BUFFER_SIZE + PARAM_READ_RND_BUFFER_SIZE + PARAM_NET_BUFFER_LENGTH) \
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
