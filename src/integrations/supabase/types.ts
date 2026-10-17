export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5"
  }
  public: {
    Tables: {
      devices: {
        Row: {
          created_at: string
          device_key_hash: string
          fcm_token: string | null
          id: string
          label: string
          last_seen_at: string | null
          merchant_id: string
          platform: string | null
          updated_at: string
        }
        Insert: {
          created_at?: string
          device_key_hash: string
          fcm_token?: string | null
          id?: string
          label?: string
          last_seen_at?: string | null
          merchant_id: string
          platform?: string | null
          updated_at?: string
        }
        Update: {
          created_at?: string
          device_key_hash?: string
          fcm_token?: string | null
          id?: string
          label?: string
          last_seen_at?: string | null
          merchant_id?: string
          platform?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "devices_merchant_id_fkey"
            columns: ["merchant_id"]
            isOneToOne: false
            referencedRelation: "merchants"
            referencedColumns: ["id"]
          },
        ]
      }
      menu_items: {
        Row: {
          available: boolean
          category: string
          ext_id: string
          id: string
          name: string
          price_paise: number
          published: boolean
          shop_id: string
          sort: number
          updated_at: string
        }
        Insert: {
          available?: boolean
          category?: string
          ext_id: string
          id?: string
          name: string
          price_paise: number
          published?: boolean
          shop_id: string
          sort?: number
          updated_at?: string
        }
        Update: {
          available?: boolean
          category?: string
          ext_id?: string
          id?: string
          name?: string
          price_paise?: number
          published?: boolean
          shop_id?: string
          sort?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "menu_items_shop_id_fkey"
            columns: ["shop_id"]
            isOneToOne: false
            referencedRelation: "shops"
            referencedColumns: ["id"]
          },
        ]
      }
      merchants: {
        Row: {
          created_at: string
          id: string
          merchant_ref: string
          name: string
          pairing_code: string
          provider: string
          updated_at: string
          vpa: string | null
        }
        Insert: {
          created_at?: string
          id?: string
          merchant_ref: string
          name: string
          pairing_code: string
          provider: string
          updated_at?: string
          vpa?: string | null
        }
        Update: {
          created_at?: string
          id?: string
          merchant_ref?: string
          name?: string
          pairing_code?: string
          provider?: string
          updated_at?: string
          vpa?: string | null
        }
        Relationships: []
      }
      order_items: {
        Row: {
          ext_id: string
          id: string
          menu_item_id: string | null
          name: string
          note: string
          order_id: string
          price_paise: number
          qty: number
        }
        Insert: {
          ext_id?: string
          id?: string
          menu_item_id?: string | null
          name: string
          note?: string
          order_id: string
          price_paise: number
          qty: number
        }
        Update: {
          ext_id?: string
          id?: string
          menu_item_id?: string | null
          name?: string
          note?: string
          order_id?: string
          price_paise?: number
          qty?: number
        }
        Relationships: [
          {
            foreignKeyName: "order_items_menu_item_id_fkey"
            columns: ["menu_item_id"]
            isOneToOne: false
            referencedRelation: "menu_items"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "order_items_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "orders"
            referencedColumns: ["id"]
          },
        ]
      }
      orders: {
        Row: {
          cancel_reason: string
          created_at: string
          customer_name: string
          customer_phone: string
          id: string
          payment_state: string
          shop_id: string
          source: string
          status: string
          subtotal_paise: number
          table_label: string
          token: number
          updated_at: string
        }
        Insert: {
          cancel_reason?: string
          created_at?: string
          customer_name?: string
          customer_phone?: string
          id?: string
          payment_state?: string
          shop_id: string
          source?: string
          status?: string
          subtotal_paise?: number
          table_label?: string
          token: number
          updated_at?: string
        }
        Update: {
          cancel_reason?: string
          created_at?: string
          customer_name?: string
          customer_phone?: string
          id?: string
          payment_state?: string
          shop_id?: string
          source?: string
          status?: string
          subtotal_paise?: number
          table_label?: string
          token?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "orders_shop_id_fkey"
            columns: ["shop_id"]
            isOneToOne: false
            referencedRelation: "shops"
            referencedColumns: ["id"]
          },
        ]
      }
      payment_acks: {
        Row: {
          announced_at: string
          device_id: string
          payment_id: string
        }
        Insert: {
          announced_at?: string
          device_id: string
          payment_id: string
        }
        Update: {
          announced_at?: string
          device_id?: string
          payment_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "payment_acks_device_id_fkey"
            columns: ["device_id"]
            isOneToOne: false
            referencedRelation: "devices"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "payment_acks_payment_id_fkey"
            columns: ["payment_id"]
            isOneToOne: false
            referencedRelation: "upi_payments"
            referencedColumns: ["id"]
          },
        ]
      }
      service_requests: {
        Row: {
          created_at: string
          handled_at: string | null
          id: string
          kind: string
          shop_id: string
          table_label: string
        }
        Insert: {
          created_at?: string
          handled_at?: string | null
          id?: string
          kind: string
          shop_id: string
          table_label?: string
        }
        Update: {
          created_at?: string
          handled_at?: string | null
          id?: string
          kind?: string
          shop_id?: string
          table_label?: string
        }
        Relationships: [
          {
            foreignKeyName: "service_requests_shop_id_fkey"
            columns: ["shop_id"]
            isOneToOne: false
            referencedRelation: "shops"
            referencedColumns: ["id"]
          },
        ]
      }
      shop_backups: {
        Row: {
          checksum: string
          created_at: string
          device_label: string
          id: string
          payload: string
          shop_id: string
          size_bytes: number
        }
        Insert: {
          checksum?: string
          created_at?: string
          device_label?: string
          id?: string
          payload: string
          shop_id: string
          size_bytes?: number
        }
        Update: {
          checksum?: string
          created_at?: string
          device_label?: string
          id?: string
          payload?: string
          shop_id?: string
          size_bytes?: number
        }
        Relationships: [
          {
            foreignKeyName: "shop_backups_shop_id_fkey"
            columns: ["shop_id"]
            isOneToOne: false
            referencedRelation: "shops"
            referencedColumns: ["id"]
          },
        ]
      }
      shop_devices: {
        Row: {
          active: boolean
          created_at: string
          device_key_hash: string
          id: string
          label: string
          last_seen_at: string | null
          role_hint: string
          role_id: string | null
          shop_id: string
          updated_at: string
        }
        Insert: {
          active?: boolean
          created_at?: string
          device_key_hash: string
          id?: string
          label?: string
          last_seen_at?: string | null
          role_hint?: string
          role_id?: string | null
          shop_id: string
          updated_at?: string
        }
        Update: {
          active?: boolean
          created_at?: string
          device_key_hash?: string
          id?: string
          label?: string
          last_seen_at?: string | null
          role_hint?: string
          role_id?: string | null
          shop_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "shop_devices_shop_id_fkey"
            columns: ["shop_id"]
            isOneToOne: false
            referencedRelation: "shops"
            referencedColumns: ["id"]
          },
        ]
      }
      shop_pairing_codes: {
        Row: {
          code: string
          created_at: string
          expires_at: string
          id: string
          role_hint: string
          shop_id: string
          used_at: string | null
        }
        Insert: {
          code: string
          created_at?: string
          expires_at: string
          id?: string
          role_hint?: string
          shop_id: string
          used_at?: string | null
        }
        Update: {
          code?: string
          created_at?: string
          expires_at?: string
          id?: string
          role_hint?: string
          shop_id?: string
          used_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "shop_pairing_codes_shop_id_fkey"
            columns: ["shop_id"]
            isOneToOne: false
            referencedRelation: "shops"
            referencedColumns: ["id"]
          },
        ]
      }
      shop_roles: {
        Row: {
          active: boolean
          created_at: string
          id: string
          max_credit_paise: number
          max_discount_paise: number
          max_refund_paise: number
          name: string
          permissions: string[]
          role_id: string
          shop_id: string
          updated_at: string
        }
        Insert: {
          active?: boolean
          created_at?: string
          id?: string
          max_credit_paise?: number
          max_discount_paise?: number
          max_refund_paise?: number
          name?: string
          permissions?: string[]
          role_id: string
          shop_id: string
          updated_at?: string
        }
        Update: {
          active?: boolean
          created_at?: string
          id?: string
          max_credit_paise?: number
          max_discount_paise?: number
          max_refund_paise?: number
          name?: string
          permissions?: string[]
          role_id?: string
          shop_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "shop_roles_shop_id_fkey"
            columns: ["shop_id"]
            isOneToOne: false
            referencedRelation: "shops"
            referencedColumns: ["id"]
          },
        ]
      }
      shop_subscriptions: {
        Row: {
          created_at: string
          current_period_end: string | null
          id: string
          plan: string
          provider: string
          provider_ref: string
          shop_id: string
          status: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          current_period_end?: string | null
          id?: string
          plan?: string
          provider?: string
          provider_ref?: string
          shop_id: string
          status?: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          current_period_end?: string | null
          id?: string
          plan?: string
          provider?: string
          provider_ref?: string
          shop_id?: string
          status?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "shop_subscriptions_shop_id_fkey"
            columns: ["shop_id"]
            isOneToOne: true
            referencedRelation: "shops"
            referencedColumns: ["id"]
          },
        ]
      }
      shops: {
        Row: {
          address: string
          allow_call_staff: boolean
          allow_request_bill: boolean
          created_at: string
          fssai: string
          gstin: string
          id: string
          is_open: boolean
          key_hash: string
          name: string
          pay_mode: string
          phone: string
          service_mode: string
          slug: string
          tax_percent: number
          updated_at: string
          vpa: string
        }
        Insert: {
          address?: string
          allow_call_staff?: boolean
          allow_request_bill?: boolean
          created_at?: string
          fssai?: string
          gstin?: string
          id?: string
          is_open?: boolean
          key_hash: string
          name?: string
          pay_mode?: string
          phone?: string
          service_mode?: string
          slug: string
          tax_percent?: number
          updated_at?: string
          vpa?: string
        }
        Update: {
          address?: string
          allow_call_staff?: boolean
          allow_request_bill?: boolean
          created_at?: string
          fssai?: string
          gstin?: string
          id?: string
          is_open?: boolean
          key_hash?: string
          name?: string
          pay_mode?: string
          phone?: string
          service_mode?: string
          slug?: string
          tax_percent?: number
          updated_at?: string
          vpa?: string
        }
        Relationships: []
      }
      upi_payments: {
        Row: {
          amount_paise: number
          created_at: string
          currency: string
          id: string
          merchant_id: string
          note: string | null
          occurred_at: string
          order_tag: string | null
          payer_name: string | null
          payer_vpa: string | null
          provider: string
          provider_txn_id: string
          raw: Json
          status: string
          utr: string | null
        }
        Insert: {
          amount_paise: number
          created_at?: string
          currency?: string
          id?: string
          merchant_id: string
          note?: string | null
          occurred_at?: string
          order_tag?: string | null
          payer_name?: string | null
          payer_vpa?: string | null
          provider: string
          provider_txn_id: string
          raw?: Json
          status?: string
          utr?: string | null
        }
        Update: {
          amount_paise?: number
          created_at?: string
          currency?: string
          id?: string
          merchant_id?: string
          note?: string | null
          occurred_at?: string
          order_tag?: string | null
          payer_name?: string | null
          payer_vpa?: string | null
          provider?: string
          provider_txn_id?: string
          raw?: Json
          status?: string
          utr?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "upi_payments_merchant_id_fkey"
            columns: ["merchant_id"]
            isOneToOne: false
            referencedRelation: "merchants"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      board_feed: {
        Args: { p_key: string; p_since?: string; p_slug: string }
        Returns: Json
      }
      counter_order_push: {
        Args: {
          p_items: Json
          p_key: string
          p_slug: string
          p_table: string
          p_token: number
        }
        Returns: string
      }
      device_board_feed: {
        Args: { p_device_key: string; p_since?: string; p_slug: string }
        Returns: Json
      }
      device_counter_order_push: {
        Args: {
          p_device_key: string
          p_items: Json
          p_slug: string
          p_table: string
          p_token: number
        }
        Returns: string
      }
      device_heartbeat: {
        Args: { device_key: string; fcm_token?: string }
        Returns: Json
      }
      device_order_set_paid: {
        Args: {
          p_device_key: string
          p_order: string
          p_paid?: boolean
          p_slug: string
        }
        Returns: boolean
      }
      device_order_set_status: {
        Args: {
          p_device_key: string
          p_order: string
          p_reason?: string
          p_slug: string
          p_status: string
        }
        Returns: boolean
      }
      device_pair: {
        Args: {
          fcm_token?: string
          label?: string
          pairing_code: string
          platform?: string
        }
        Returns: Json
      }
      device_permits: {
        Args: {
          p_device_key: string
          p_hints: string[]
          p_permission: string
          p_shop: string
        }
        Returns: boolean
      }
      device_profile: {
        Args: { p_device_key: string; p_slug: string }
        Returns: Json
      }
      device_service_feed: {
        Args: { p_device_key: string; p_slug: string }
        Returns: Json
      }
      device_service_request_seen: {
        Args: { p_device_key: string; p_request: string; p_slug: string }
        Returns: boolean
      }
      menu_for_shop: { Args: { p_slug: string }; Returns: Json }
      menu_publish: {
        Args: { p_items: Json; p_key: string; p_slug: string }
        Returns: number
      }
      menu_set_available: {
        Args: {
          p_available: boolean
          p_ext_id: string
          p_key: string
          p_slug: string
        }
        Returns: boolean
      }
      merchant_register: {
        Args: {
          business_name: string
          merchant_ref: string
          paytm_webhook_token?: string
          phonepe_salt_index?: string
          phonepe_salt_key?: string
          provider: string
          vpa?: string
        }
        Returns: Json
      }
      order_set_paid: {
        Args: {
          p_key: string
          p_order: string
          p_paid?: boolean
          p_slug: string
        }
        Returns: boolean
      }
      order_set_status: {
        Args: {
          p_key: string
          p_order: string
          p_reason?: string
          p_slug: string
          p_status: string
        }
        Returns: boolean
      }
      payment_ack: {
        Args: { device_key: string; payment_ids: string[] }
        Returns: Json
      }
      payment_feed: {
        Args: { device_key: string; max_rows?: number }
        Returns: Json
      }
      paytm_webhook: { Args: { body: Json; head: Json }; Returns: Json }
      phonepe_webhook: { Args: { response: string }; Returns: Json }
      place_menu_order: {
        Args: {
          p_items: Json
          p_name: string
          p_phone: string
          p_slug: string
          p_table: string
        }
        Returns: Json
      }
      service_feed: { Args: { p_key: string; p_slug: string }; Returns: Json }
      service_request_push: {
        Args: { p_kind: string; p_slug: string; p_table: string }
        Returns: boolean
      }
      service_request_seen: {
        Args: { p_key: string; p_request: string; p_slug: string }
        Returns: boolean
      }
      shop_backup_latest: {
        Args: { p_key: string; p_slug: string; p_with_payload?: boolean }
        Returns: Json
      }
      shop_backup_put: {
        Args: {
          p_checksum?: string
          p_key: string
          p_label?: string
          p_payload: string
          p_slug: string
        }
        Returns: Json
      }
      shop_device_code_create: {
        Args: {
          p_key: string
          p_label?: string
          p_role_hint?: string
          p_slug: string
        }
        Returns: Json
      }
      shop_device_pair: {
        Args: {
          p_code: string
          p_label?: string
          p_role_hint?: string
          p_slug: string
        }
        Returns: Json
      }
      shop_device_ping: {
        Args: { p_device_key: string; p_slug: string }
        Returns: Json
      }
      shop_device_revoke: {
        Args: { p_device: string; p_key: string; p_slug: string }
        Returns: boolean
      }
      shop_device_set_role: {
        Args: {
          p_device: string
          p_key: string
          p_role_id: string
          p_slug: string
        }
        Returns: boolean
      }
      shop_devices_list: {
        Args: { p_key: string; p_slug: string }
        Returns: Json
      }
      shop_from_device: {
        Args: { p_device_key: string; p_slug: string }
        Returns: string
      }
      shop_from_key: {
        Args: { p_key: string; p_slug: string }
        Returns: string
      }
      shop_plan: { Args: { p_key: string; p_slug: string }; Returns: Json }
      shop_plan_active: { Args: { p_shop: string }; Returns: boolean }
      shop_register: {
        Args: {
          p_address?: string
          p_call_staff?: boolean
          p_fssai?: string
          p_gstin?: string
          p_key: string
          p_name?: string
          p_pay_mode?: string
          p_phone?: string
          p_request_bill?: boolean
          p_service_mode?: string
          p_slug: string
          p_tax?: number
          p_vpa?: string
        }
        Returns: Json
      }
      shop_roles_publish: {
        Args: { p_key: string; p_roles: Json; p_slug: string }
        Returns: number
      }
      shop_sales_rollup: {
        Args: { p_days?: number; p_key: string; p_slug: string }
        Returns: Json
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends (DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never) = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends (PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never) = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {},
  },
} as const
