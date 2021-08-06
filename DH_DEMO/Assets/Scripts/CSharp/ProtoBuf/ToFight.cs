// <auto-generated>
//     Generated by the protocol buffer compiler.  DO NOT EDIT!
//     source: ToFight.proto
// </auto-generated>
#pragma warning disable 1591, 0612, 3021
#region Designer generated code

using pb = global::Google.Protobuf;
using pbc = global::Google.Protobuf.Collections;
using pbr = global::Google.Protobuf.Reflection;
using scg = global::System.Collections.Generic;
namespace Network {

  /// <summary>Holder for reflection information generated from ToFight.proto</summary>
  public static partial class ToFightReflection {

    #region Descriptor
    /// <summary>File descriptor for ToFight.proto</summary>
    public static pbr::FileDescriptor Descriptor {
      get { return descriptor; }
    }
    private static pbr::FileDescriptor descriptor;

    static ToFightReflection() {
      byte[] descriptorData = global::System.Convert.FromBase64String(
          string.Concat(
            "Cg1Ub0ZpZ2h0LnByb3RvEgduZXR3b3JrIioKB1RvRmlnaHQSDgoGbXlOYW1l",
            "GAEgASgJEg8KB2hpc05hbWUYAiABKAliBnByb3RvMw=="));
      descriptor = pbr::FileDescriptor.FromGeneratedCode(descriptorData,
          new pbr::FileDescriptor[] { },
          new pbr::GeneratedClrTypeInfo(null, new pbr::GeneratedClrTypeInfo[] {
            new pbr::GeneratedClrTypeInfo(typeof(global::Network.ToFight), global::Network.ToFight.Parser, new[]{ "MyName", "HisName" }, null, null, null)
          }));
    }
    #endregion

  }
  #region Messages
  public sealed partial class ToFight : pb::IMessage<ToFight> {
    private static readonly pb::MessageParser<ToFight> _parser = new pb::MessageParser<ToFight>(() => new ToFight());
    private pb::UnknownFieldSet _unknownFields;
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public static pb::MessageParser<ToFight> Parser { get { return _parser; } }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public static pbr::MessageDescriptor Descriptor {
      get { return global::Network.ToFightReflection.Descriptor.MessageTypes[0]; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    pbr::MessageDescriptor pb::IMessage.Descriptor {
      get { return Descriptor; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public ToFight() {
      OnConstruction();
    }

    partial void OnConstruction();

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public ToFight(ToFight other) : this() {
      myName_ = other.myName_;
      hisName_ = other.hisName_;
      _unknownFields = pb::UnknownFieldSet.Clone(other._unknownFields);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public ToFight Clone() {
      return new ToFight(this);
    }

    /// <summary>Field number for the "myName" field.</summary>
    public const int MyNameFieldNumber = 1;
    private string myName_ = "";
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public string MyName {
      get { return myName_; }
      set {
        myName_ = pb::ProtoPreconditions.CheckNotNull(value, "value");
      }
    }

    /// <summary>Field number for the "hisName" field.</summary>
    public const int HisNameFieldNumber = 2;
    private string hisName_ = "";
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public string HisName {
      get { return hisName_; }
      set {
        hisName_ = pb::ProtoPreconditions.CheckNotNull(value, "value");
      }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override bool Equals(object other) {
      return Equals(other as ToFight);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public bool Equals(ToFight other) {
      if (ReferenceEquals(other, null)) {
        return false;
      }
      if (ReferenceEquals(other, this)) {
        return true;
      }
      if (MyName != other.MyName) return false;
      if (HisName != other.HisName) return false;
      return Equals(_unknownFields, other._unknownFields);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override int GetHashCode() {
      int hash = 1;
      if (MyName.Length != 0) hash ^= MyName.GetHashCode();
      if (HisName.Length != 0) hash ^= HisName.GetHashCode();
      if (_unknownFields != null) {
        hash ^= _unknownFields.GetHashCode();
      }
      return hash;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override string ToString() {
      return pb::JsonFormatter.ToDiagnosticString(this);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void WriteTo(pb::CodedOutputStream output) {
      if (MyName.Length != 0) {
        output.WriteRawTag(10);
        output.WriteString(MyName);
      }
      if (HisName.Length != 0) {
        output.WriteRawTag(18);
        output.WriteString(HisName);
      }
      if (_unknownFields != null) {
        _unknownFields.WriteTo(output);
      }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public int CalculateSize() {
      int size = 0;
      if (MyName.Length != 0) {
        size += 1 + pb::CodedOutputStream.ComputeStringSize(MyName);
      }
      if (HisName.Length != 0) {
        size += 1 + pb::CodedOutputStream.ComputeStringSize(HisName);
      }
      if (_unknownFields != null) {
        size += _unknownFields.CalculateSize();
      }
      return size;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void MergeFrom(ToFight other) {
      if (other == null) {
        return;
      }
      if (other.MyName.Length != 0) {
        MyName = other.MyName;
      }
      if (other.HisName.Length != 0) {
        HisName = other.HisName;
      }
      _unknownFields = pb::UnknownFieldSet.MergeFrom(_unknownFields, other._unknownFields);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void MergeFrom(pb::CodedInputStream input) {
      uint tag;
      while ((tag = input.ReadTag()) != 0) {
        switch(tag) {
          default:
            _unknownFields = pb::UnknownFieldSet.MergeFieldFrom(_unknownFields, input);
            break;
          case 10: {
            MyName = input.ReadString();
            break;
          }
          case 18: {
            HisName = input.ReadString();
            break;
          }
        }
      }
    }

  }

  #endregion

}

#endregion Designer generated code
