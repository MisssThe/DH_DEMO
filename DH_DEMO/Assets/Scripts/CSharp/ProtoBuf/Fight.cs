// <auto-generated>
//     Generated by the protocol buffer compiler.  DO NOT EDIT!
//     source: Fight.proto
// </auto-generated>
#pragma warning disable 1591, 0612, 3021
#region Designer generated code

using pb = global::Google.Protobuf;
using pbc = global::Google.Protobuf.Collections;
using pbr = global::Google.Protobuf.Reflection;
using scg = global::System.Collections.Generic;
namespace Network {

  /// <summary>Holder for reflection information generated from Fight.proto</summary>
  public static partial class FightReflection {

    #region Descriptor
    /// <summary>File descriptor for Fight.proto</summary>
    public static pbr::FileDescriptor Descriptor {
      get { return descriptor; }
    }
    private static pbr::FileDescriptor descriptor;

    static FightReflection() {
      byte[] descriptorData = global::System.Convert.FromBase64String(
          string.Concat(
            "CgtGaWdodC5wcm90bxIHbmV0d29yaxoLRXZlbnQucHJvdG8iWQoFRmlnaHQS",
            "HQoFZXZlbnQYASABKAsyDi5uZXR3b3JrLkV2ZW50Eg4KBm15TmFtZRgCIAEo",
            "CRIPCgdoaXNOYW1lGAMgASgJEhAKCGNhckluZGV4GAQgASgFYgZwcm90bzM="));
      descriptor = pbr::FileDescriptor.FromGeneratedCode(descriptorData,
          new pbr::FileDescriptor[] { global::Network.EventReflection.Descriptor, },
          new pbr::GeneratedClrTypeInfo(null, new pbr::GeneratedClrTypeInfo[] {
            new pbr::GeneratedClrTypeInfo(typeof(global::Network.Fight), global::Network.Fight.Parser, new[]{ "Event", "MyName", "HisName", "CarIndex" }, null, null, null)
          }));
    }
    #endregion

  }
  #region Messages
  public sealed partial class Fight : pb::IMessage<Fight> {
    private static readonly pb::MessageParser<Fight> _parser = new pb::MessageParser<Fight>(() => new Fight());
    private pb::UnknownFieldSet _unknownFields;
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public static pb::MessageParser<Fight> Parser { get { return _parser; } }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public static pbr::MessageDescriptor Descriptor {
      get { return global::Network.FightReflection.Descriptor.MessageTypes[0]; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    pbr::MessageDescriptor pb::IMessage.Descriptor {
      get { return Descriptor; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public Fight() {
      OnConstruction();
    }

    partial void OnConstruction();

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public Fight(Fight other) : this() {
      event_ = other.event_ != null ? other.event_.Clone() : null;
      myName_ = other.myName_;
      hisName_ = other.hisName_;
      carIndex_ = other.carIndex_;
      _unknownFields = pb::UnknownFieldSet.Clone(other._unknownFields);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public Fight Clone() {
      return new Fight(this);
    }

    /// <summary>Field number for the "event" field.</summary>
    public const int EventFieldNumber = 1;
    private global::Network.Event event_;
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public global::Network.Event Event {
      get { return event_; }
      set {
        event_ = value;
      }
    }

    /// <summary>Field number for the "myName" field.</summary>
    public const int MyNameFieldNumber = 2;
    private string myName_ = "";
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public string MyName {
      get { return myName_; }
      set {
        myName_ = pb::ProtoPreconditions.CheckNotNull(value, "value");
      }
    }

    /// <summary>Field number for the "hisName" field.</summary>
    public const int HisNameFieldNumber = 3;
    private string hisName_ = "";
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public string HisName {
      get { return hisName_; }
      set {
        hisName_ = pb::ProtoPreconditions.CheckNotNull(value, "value");
      }
    }

    /// <summary>Field number for the "carIndex" field.</summary>
    public const int CarIndexFieldNumber = 4;
    private int carIndex_;
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public int CarIndex {
      get { return carIndex_; }
      set {
        carIndex_ = value;
      }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override bool Equals(object other) {
      return Equals(other as Fight);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public bool Equals(Fight other) {
      if (ReferenceEquals(other, null)) {
        return false;
      }
      if (ReferenceEquals(other, this)) {
        return true;
      }
      if (!object.Equals(Event, other.Event)) return false;
      if (MyName != other.MyName) return false;
      if (HisName != other.HisName) return false;
      if (CarIndex != other.CarIndex) return false;
      return Equals(_unknownFields, other._unknownFields);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override int GetHashCode() {
      int hash = 1;
      if (event_ != null) hash ^= Event.GetHashCode();
      if (MyName.Length != 0) hash ^= MyName.GetHashCode();
      if (HisName.Length != 0) hash ^= HisName.GetHashCode();
      if (CarIndex != 0) hash ^= CarIndex.GetHashCode();
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
      if (event_ != null) {
        output.WriteRawTag(10);
        output.WriteMessage(Event);
      }
      if (MyName.Length != 0) {
        output.WriteRawTag(18);
        output.WriteString(MyName);
      }
      if (HisName.Length != 0) {
        output.WriteRawTag(26);
        output.WriteString(HisName);
      }
      if (CarIndex != 0) {
        output.WriteRawTag(32);
        output.WriteInt32(CarIndex);
      }
      if (_unknownFields != null) {
        _unknownFields.WriteTo(output);
      }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public int CalculateSize() {
      int size = 0;
      if (event_ != null) {
        size += 1 + pb::CodedOutputStream.ComputeMessageSize(Event);
      }
      if (MyName.Length != 0) {
        size += 1 + pb::CodedOutputStream.ComputeStringSize(MyName);
      }
      if (HisName.Length != 0) {
        size += 1 + pb::CodedOutputStream.ComputeStringSize(HisName);
      }
      if (CarIndex != 0) {
        size += 1 + pb::CodedOutputStream.ComputeInt32Size(CarIndex);
      }
      if (_unknownFields != null) {
        size += _unknownFields.CalculateSize();
      }
      return size;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void MergeFrom(Fight other) {
      if (other == null) {
        return;
      }
      if (other.event_ != null) {
        if (event_ == null) {
          Event = new global::Network.Event();
        }
        Event.MergeFrom(other.Event);
      }
      if (other.MyName.Length != 0) {
        MyName = other.MyName;
      }
      if (other.HisName.Length != 0) {
        HisName = other.HisName;
      }
      if (other.CarIndex != 0) {
        CarIndex = other.CarIndex;
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
            if (event_ == null) {
              Event = new global::Network.Event();
            }
            input.ReadMessage(Event);
            break;
          }
          case 18: {
            MyName = input.ReadString();
            break;
          }
          case 26: {
            HisName = input.ReadString();
            break;
          }
          case 32: {
            CarIndex = input.ReadInt32();
            break;
          }
        }
      }
    }

  }

  #endregion

}

#endregion Designer generated code